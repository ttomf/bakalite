import 'dart:math' as math;

import 'package:bakalite/api.dart';
import 'package:bakalite/data/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/timetable_grid.dart';
import 'package:bakalite/widgets/timetable_grid_flex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime? _cacheTimestamp;
  Map<String, dynamic>? _timetable;
  List<Map<String, dynamic>>? _timetableParsed;
  List<dynamic>? _timetableHours;
  Map<String, Map<String?, List<String>>> _idMaps = {};
  Map<String, dynamic>? _timetablePerm;
  List<Map<String, dynamic>>? _timetablePermParsed;
  List<dynamic>? _timetablePermHours;
  Map<String, Map<String?, List<String>>> _idMapsPerm = {};

  late DateTime _selectedDate;

  double? _scrollOffset;

  late final ScrollController _actualScrollController = _createScrollController(
    () => _timetableHours,
  );
  late final ScrollController _permScrollController = _createScrollController(
    () => _timetablePermHours,
  );

  ScrollController _createScrollController(List<dynamic>? Function() hours) {
    return ScrollController(
      keepScrollOffset: false,
      onAttach: (position) {
        position.addListener(() => _scrollOffset = position.pixels);
        position.correctPixels(
          _scrollOffset ??
              math.max(
                0,
                _lessonCenter(hours()) - MediaQuery.sizeOf(context).width / 2,
              ),
        );
      },
    );
  }

  double _lessonCenter(List<dynamic>? hours) {
    if (hours == null || hours.isEmpty) return 0;

    final now = DateTime.now();
    final minutes = now.hour * 60 + now.minute;
    var index = hours.indexWhere(
      (hour) => minutes < hour['Start'] + hour['Duration'],
    );
    if (index < 0) index = hours.length - 1;

    if (Config.flexTimetable.value) {
      return (hours[index]['Start'] -
              hours.first['Start'] +
              hours[index]['Duration'] / 2) *
          TimetableGridFlex.pixelsPerMinute;
    } else {
      return (index + 0.5) * TimetableGrid.containerWidth;
    }
  }

  int _loadId = 0;
  bool _loaded = false;
  bool _loadedPerm = false;
  bool _error = false;
  bool _errorPerm = false;

  DateTime _addDays(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }

  DateTime _weekStart(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday + 1);
  }

  @override
  void initState() {
    _selectedDate = _weekStart(DateTime.now());
    super.initState();
    _load(offline: !Config.autoRefresh.value);
    _loadPerm(offline: !Config.autoRefresh.value);
  }

  @override
  void dispose() {
    _actualScrollController.dispose();
    _permScrollController.dispose();
    super.dispose();
  }

  Future<void> _load({
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) async {
    _error = false;
    final loadId = ++_loadId;
    final selectedDate = _selectedDate;

    try {
      final cached = useCache
          ? await cache.load(
              'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
            )
          : null;
      final timetableData =
          cached?['data'] ??
          (offline
              ? null
              : await api.fetch(
                  'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                ));

      if (!mounted || loadId != _loadId) return;

      if (timetableData != null) {
        setState(() {
          _timetable = timetableData;
          _loaded = true;
          _idMaps = {
            for (final category in [
              'Classes',
              'Groups',
              'Subjects',
              'Teachers',
              'Rooms',
              'Cycles',
            ])
              category: {
                for (final subject in _timetable?[category] ?? [])
                  subject['Id']: [subject['Abbrev'], subject['Name']],
              },
          };
          _timetableParsed = [
            for (final day in _timetable?['Days'])
              {
                'Date': parseTime(day['Date']),
                'DayType': day['DayType'],
                'DayDescription': day['DayDescription'],
                'Atoms': _parseAtoms(
                  day['Atoms'] ?? [],
                  actual: true,
                  date: parseTime(day['Date']),
                ),
              },
          ];
          _timetableHours = _timetable?['Hours'];
        });
        if (cached == null) {
          setState(() {
            _cacheTimestamp = null;
          });
        }
      }
      if (cached != null) {
        setState(() {
          _cacheTimestamp = DateTime.fromMillisecondsSinceEpoch(
            cached['timestamp'],
          );
        });
        if (!offline) {
          _load(useCache: false);
        }
      }
    } on BakaLiteException catch (e) {
      if (!mounted || loadId != _loadId) return;
      setState(() {
        _error = true;
      });
      if (e.error == BakaLiteError.network && !throwNetwork) return;
      showError(context, e);
    }
  }

  Future<void> _loadPerm({
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) async {
    try {
      _errorPerm = false;
      final cached = useCache ? await cache.load('timetable/permanent') : null;
      final timetablePermData =
          cached?['data'] ??
          (offline ? null : await api.fetch('timetable/permanent'));

      if (!mounted) return;

      if (timetablePermData != null) {
        setState(() {
          _timetablePerm = timetablePermData;
          _loadedPerm = true;
          _idMapsPerm = {
            for (final category in [
              'Classes',
              'Groups',
              'Subjects',
              'Teachers',
              'Rooms',
              'Cycles',
            ])
              category: {
                for (final subject in _timetablePerm?[category] ?? [])
                  subject['Id']: [subject['Abbrev'], subject['Name']],
              },
          };
          _timetablePermParsed = [
            for (final day in _timetablePerm?['Days'])
              {'Atoms': _parseAtoms(day['Atoms'] ?? [], actual: false)},
          ];
          _timetablePermHours = _timetablePerm?['Hours'];
        });
      }
      if (cached != null) {
        setState(() {
          _cacheTimestamp = DateTime.fromMillisecondsSinceEpoch(
            cached['timestamp'],
          );
        });
        if (!offline) {
          _loadPerm(useCache: false);
        }
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorPerm = true;
      });
      if (e.error == BakaLiteError.network && !throwNetwork) return;
      showError(context, e);
    }
  }

  List<Map<String, dynamic>> _parseAtoms(
    List atoms, {
    bool actual = true,
    DateTime? date,
  }) {
    final idMaps = actual ? _idMaps : _idMapsPerm;
    final List<Map<String, dynamic>> res = [];

    for (final hour in atoms) {
      final now = DateTime.now();
      final nowMinutes = now.hour * 60 + now.minute;
      res.add({
        'Subject': idMaps['Subjects']?[hour['SubjectId']],
        'Teacher': idMaps['Teachers']?[hour['TeacherId']],
        'Room': idMaps['Rooms']?[hour['RoomId']],
        'Groups': hour['GroupIds'].map((id) => idMaps['Groups']?[id]).toList(),
        'Start': hour['Start'],
        'Duration': hour['Duration'],
        'HourId': hour['HourId'],
        if (actual) 'Start': hour['Change']?['Start'] ?? hour['Start'],
        if (actual) 'Duration': hour['Change']?['Duration'] ?? hour['Duration'],
        if (actual) 'Change': hour['Change'],
        if (actual) 'Theme': hour['Theme'] ?? '',
        if (actual)
          'Now':
              date != null &&
              hour['Start'] < nowMinutes &&
              nowMinutes < (hour['Start'] + hour['Duration']) &&
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day,
      });
    }

    return res;
  }

  void _reloadActual() {
    setState(() {
      _timetable = null;
      _loaded = false;
      _timetableParsed = null;
      _timetableHours = null;
      _cacheTimestamp = null;
    });
    _load(offline: !Config.autoRefresh.value);
  }

  @override
  Widget build(BuildContext context) {
    final Function timetableGrid = Config.flexTimetable.value
        ? TimetableGridFlex.new
        : TimetableGrid.new;

    return Wrapper(
      title: AppLocalizations.of(context)!.timetable,
      subtitle: getCacheInfo(
        context,
        _cacheTimestamp,
        _loaded && _loadedPerm,
        _error || _errorPerm,
      ),
      tabs: [
        AppLocalizations.of(context)!.actual,
        AppLocalizations.of(context)!.permanent,
      ],
      onRefresh: () {
        setState(() {
          _loaded = false;
          _loadedPerm = false;
          _timetable = null;
          _timetablePerm = null;
        });
        _load(useCache: false, throwNetwork: true);
        _loadPerm(useCache: false, throwNetwork: true);
      },
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  icon: const Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _addDays(_selectedDate, -7);
                    });
                    _reloadActual();
                  },
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(switch (Config.relativeDateLabels.value
                        ? _selectedDate
                              .difference(_weekStart(DateTime.now()))
                              .inDays
                        : null) {
                      -7 => AppLocalizations.of(context)!.previousWeek,
                      0 => AppLocalizations.of(context)!.thisWeek,
                      7 => AppLocalizations.of(context)!.nextWeek,
                      _ =>
                        '${DateFormat('d. M. yyyy').format(_selectedDate)} – ${DateFormat('d. M. yyyy').format(_addDays(_selectedDate, 4))}',
                    }),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365 * 2),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 2),
                        ),
                      );
                      if (date == null || !mounted) return;
                      setState(() {
                        _selectedDate = _weekStart(date);
                      });
                      _reloadActual();
                    },
                    onLongPress: () {
                      setState(() {
                        _selectedDate = _weekStart(DateTime.now());
                      });
                      _reloadActual();
                    },
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _addDays(_selectedDate, 7);
                    });
                    _reloadActual();
                  },
                ),
              ],
            ),
            Expanded(
              child: _timetableParsed != null && _timetableHours != null
                  ? timetableGrid(
                      _timetableParsed!,
                      _timetableHours!,
                      _actualScrollController,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        _timetablePermParsed != null && _timetablePermHours != null
            ? timetableGrid(
                _timetablePermParsed!,
                _timetablePermHours!,
                _permScrollController,
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
