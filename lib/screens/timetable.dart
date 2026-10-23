import 'package:bakalite/api.dart';
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

  @override
  void initState() {
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day - now.weekday + 1);
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    final selectedDate = _selectedDate;

    try {
      final timetableData =
          _timetable ??
          await api.fetch(
            'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(selectedDate)}',
          );

      final timetablePermData =
          _timetablePerm ?? await api.fetch('timetable/permanent');

      if (!mounted || loadId != _loadId) return;

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
                  'Room': _idMaps['Rooms']?[matchingHour['RoomId']] ?? ['', ''],
                  'Change': matchingHour['Change'],
                  'Theme': matchingHour['Theme'] ?? '',
                  'Groups': matchingHour['GroupIds'].map(
                    (id) => _idMaps['Groups']?[id] ?? ['', ''],
                  ),
                };
              }),
            },
        ];
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
              'Atoms': List.generate(_timetablePerm!['Hours'].length, (index) {
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
    } catch (e) {
      if (!mounted || loadId != _loadId) return;
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  child: const Icon(Icons.exposure_minus_1),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day - 7,
                      );
                      _timetable = null;
                      _timetableParsed = null;
                    });
                    _load();
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    '${DateFormat('d. M. yyyy').format(_selectedDate)} – ${DateFormat('d. M. yyyy').format(_selectedDate.add(const Duration(days: 4)))}',
                  ),
                  onPressed: () {
                    setState(() {
                      final now = DateTime.now();
                      _selectedDate = DateTime(
                        now.year,
                        now.month,
                        now.day - now.weekday + 1,
                      );
                      _timetable = null;
                      _timetableParsed = null;
                    });
                    _load();
                  },
                ),
                FilledButton(
                  child: const Icon(Icons.exposure_plus_1),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day + 7,
                      );
                      _timetable = null;
                      _timetableParsed = null;
                    });
                    _load();
                  },
                ),
              ],
            ),
            if (_timetableParsed != null)
              Expanded(child: TimetableGrid(_timetableParsed!)),
          ],
        ),
        Column(
          children: [
            if (_timetableParsed != null)
              Expanded(child: TimetableGrid(_timetablePermParsed!)),
          ],
        ),
      ],
    );
  }
}
