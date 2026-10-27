import 'package:bakalite/accounts.dart';
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
  Map<String, dynamic>? _timetable;
  List<Map<String, dynamic>>? _timetableParsed;
  Map<String, Map<String?, List<String>>> _idMaps = {};
  Map<String, dynamic>? _timetablePerm;
  List<Map<String, dynamic>>? _timetablePermParsed;
  Map<String, Map<String?, List<String>>> _idMapsPerm = {};

  late DateTime _selectedDate;

  int _loadId = 0;

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
    _load();
    _loadPerm();
  }

  Future<void> _load([bool useCache = true]) async {
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
          await api.fetch(
            'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
          );

      if (!mounted || loadId != _loadId) return;

      if (timetableData != null) {
        setState(() {
          _timetable = timetableData;
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
                null: ['', ''],
                for (final subject in _timetable![category])
                  subject['Id']: [subject['Abbrev'], subject['Name']],
              },
          };
          _timetableParsed = [
            for (final day in _timetable!['Days'])
              {
                'Date': parseTime(day['Date']),
                'Atoms': List.generate(_timetable!['Hours'].length, (index) {
                  final hour = _timetable!['Hours'][index];
                  final matchingHour = day['Atoms'].firstWhere(
                    (h) => h['HourId'] == hour['Id'],
                    orElse: () => null,
                  );
                  if (matchingHour == null) {
                    return null;
                  }
                  return {
                    'Subject':
                        _idMaps['Subjects']?[matchingHour['SubjectId']] ??
                        ['', ''],
                    'Teacher':
                        _idMaps['Teachers']?[matchingHour['TeacherId']] ??
                        ['', ''],
                    'Room':
                        _idMaps['Rooms']?[matchingHour['RoomId']] ?? ['', ''],
                    'Change': matchingHour['Change'],
                    'Theme': matchingHour['Theme'] ?? '',
                    'Groups': matchingHour['GroupIds'].map(
                      (id) => _idMaps['Groups']?[id] ?? ['', ''],
                    ),
                  };
                }),
              },
          ];
        });
      }
      if (_timetable == null && timetableData == null) {
        final account = await accountManager.getActiveAccount();
        if (account != null) {
          await api.login(account.username, account.password);
          _load();
        }
      }
      if (cached != null) {
        _load(false);
      }
    } on BakaLiteException catch (e) {
      if (!mounted || loadId != _loadId) return;
      if (e.error == BakaLiteError.network) return;
      showError(context, e);
    }
  }

  Future<void> _loadPerm([bool useCache = true]) async {
    try {
      final cached = useCache ? await cache.load('timetable/permanent') : null;
      final timetablePermData =
          cached?['data'] ?? await api.fetch('timetable/permanent');

      if (!mounted) return;

      if (timetablePermData != null) {
        setState(() {
          _timetablePerm = timetablePermData;
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
                null: ['', ''],
                for (final subject in _timetablePerm![category])
                  subject['Id']: [subject['Abbrev'], subject['Name']],
              },
          };
          _timetablePermParsed = [
            for (final day in _timetablePerm!['Days'])
              {
                'Atoms': List.generate(_timetablePerm!['Hours'].length, (
                  index,
                ) {
                  final hour = _timetablePerm!['Hours'][index];
                  final matchingHours = day['Atoms'].where(
                    (h) => h['HourId'] == hour['Id'],
                  );
                  return [
                    for (final matchingHour in matchingHours)
                      {
                        'Subject':
                            _idMapsPerm['Subjects']?[matchingHour['SubjectId']] ??
                            ['', ''],
                        'Teacher':
                            _idMapsPerm['Teachers']?[matchingHour['TeacherId']] ??
                            ['', ''],
                        'Room':
                            _idMapsPerm['Rooms']?[matchingHour['RoomId']] ??
                            ['', ''],
                        'Groups': matchingHour['GroupIds'].map(
                          (id) => _idMapsPerm['Groups']?[id] ?? ['', ''],
                        ),
                      },
                  ];
                }),
              },
          ];
        });
      }
      if (_timetablePerm == null && timetablePermData == null) {
        final account = await accountManager.getActiveAccount();
        if (account != null) {
          await api.login(account.username, account.password);
          _loadPerm();
        }
      }
      if (cached != null) {
        _loadPerm(false);
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      if (e.error == BakaLiteError.network) return;
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.timetable,
      tabs: [
        AppLocalizations.of(context)!.actual,
        AppLocalizations.of(context)!.permanent,
      ],
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
                      _timetable = null;
                      _timetableParsed = null;
                    });
                    _load();
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
                        _timetable = null;
                        _timetableParsed = null;
                      });
                      _load();
                    },
                    onLongPress: () {
                      setState(() {
                        _selectedDate = _weekStart(DateTime.now());
                        _timetable = null;
                        _timetableParsed = null;
                      });
                      _load();
                    },
                  ),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _addDays(_selectedDate, 7);
                      _timetable = null;
                      _timetableParsed = null;
                    });
                    _load();
                  },
                ),
              ],
            ),
            Expanded(
              child: _timetable != null
                  ? TimetableGrid(_timetableParsed!, _timetable!['Hours'])
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        _timetablePerm != null
            ? TimetableGrid(_timetablePermParsed!, _timetablePerm!['Hours'])
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
