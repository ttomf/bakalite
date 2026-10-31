import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/timetable_grid.dart';
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
                'Atoms': List.generate(_timetable?['Hours'].length ?? 0, (
                  index,
                ) {
                  final hour = _timetable?['Hours'][index];
                  final matchingHour = day['Atoms'].firstWhere(
                    (h) => h['HourId'] == hour['Id'],
                    orElse: () => null,
                  );
                  if (matchingHour == null) {
                    return null;
                  }
                  return {
                    'Subject': _idMaps['Subjects']?[matchingHour['SubjectId']],
                    'Teacher': _idMaps['Teachers']?[matchingHour['TeacherId']],
                    'Room': _idMaps['Rooms']?[matchingHour['RoomId']],
                    'Change': matchingHour['Change'],
                    'Theme': matchingHour['Theme'] ?? '',
                    'Groups': matchingHour['GroupIds'].map(
                      (id) => _idMaps['Groups']?[id],
                    ),
                  };
                }),
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
              {
                'Atoms': List.generate(_timetablePerm?['Hours'].length ?? 0, (
                  index,
                ) {
                  final hour = _timetablePerm?['Hours'][index];
                  final matchingHours = day['Atoms'].where(
                    (h) => h['HourId'] == hour['Id'],
                  );
                  return [
                    for (final matchingHour in matchingHours)
                      {
                        'Subject':
                            _idMapsPerm['Subjects']?[matchingHour['SubjectId']],
                        'Teacher':
                            _idMapsPerm['Teachers']?[matchingHour['TeacherId']],
                        'Room': _idMapsPerm['Rooms']?[matchingHour['RoomId']],
                        'Groups': matchingHour['GroupIds'].map(
                          (id) => _idMapsPerm['Groups']?[id],
                        ),
                      },
                  ];
                }),
              },
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
                  ? TimetableGrid(_timetableParsed!, _timetableHours!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        _timetablePermParsed != null && _timetablePermHours != null
            ? TimetableGrid(_timetablePermParsed!, _timetablePermHours!)
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
