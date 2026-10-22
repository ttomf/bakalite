import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/widgets/timetable_grid.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Map<String, dynamic>? _timetable;
  List<List<Map<String, dynamic>?>> _timetableParsed = [[], [], [], [], []];
  Map<String, Map<String?, List<String>>> _idMaps = {};
  Map<String, dynamic>? _timetablePerm;
  List<List<List<Map<String, dynamic>>>> _timetablePermParsed = [
    [],
    [],
    [],
    [],
    [],
  ];
  Map<String, Map<String?, List<String>>> _idMapsPerm = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? timetableData = _timetable;
      Map<String, dynamic>? timetablePermData = _timetablePerm;

      if (_timetable == null) {
        timetableData = await api.fetch('timetable/actual');
        timetablePermData = await api.fetch('timetable/permanent');
      }
      if (!mounted) return;

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
            List.generate(_timetable!['Hours'].length, (index) {
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
                    _idMaps['Subjects']?[matchingHour['SubjectId']] ?? ['', ''],
                'Teacher':
                    _idMaps['Teachers']?[matchingHour['TeacherId']] ?? ['', ''],
                'Room': _idMaps['Rooms']?[matchingHour['RoomId']] ?? ['', ''],
                'Change': matchingHour['Change'],
                'Theme': matchingHour['Theme'] ?? '',
                'Groups': matchingHour['GroupIds'].map(
                  (id) => _idMaps['Groups']?[id] ?? ['', ''],
                ),
              };
            }),
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
            List.generate(_timetablePerm!['Hours'].length, (index) {
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
        ];
      });
    } catch (e) {
      if (!mounted) return;
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
        TimetableGrid(_timetableParsed),
        TimetableGrid(_timetablePermParsed),
      ],
    );
  }
}
