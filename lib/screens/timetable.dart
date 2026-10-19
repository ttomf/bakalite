import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Map<String, dynamic>? _timetable;
  List<List<Map?>> _timetableParsed = [[], [], [], [], []];
  Map<String, Map<String?, List<String>>>? _idMaps;
  Map<String, dynamic>? _timetablePermanent;
  List<List<Map?>> _timetablePermanentParsed = [[], [], [], [], []];
  Map<String, Map<String?, List<String>>>? _idMapsPermanent;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? timetableData = _timetable;
      Map<String, dynamic>? timetablePermanentData = _timetablePermanent;

      if (_timetable == null) {
        timetableData = await api.fetch('timetable/actual');
        timetablePermanentData = await api.fetch('timetable/permanent');
      }
      if (!mounted) return;

      setState(() {
        _timetable = timetableData;
        _timetableParsed = [
          for (final day in _timetable!['Days'])
            List.generate(_timetable!['Hours'].length, (index) {
              final hour = _timetable!['Hours'][index];
              final matchingHour = day['Atoms'].firstWhere(
                (h) => h['HourId'] == hour['Id'],
                orElse: () => null,
              );
              return matchingHour;
            }),
        ];
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
        _timetablePermanent = timetablePermanentData;
        _timetablePermanentParsed = [
          for (final day in _timetablePermanent!['Days'])
            List.generate(_timetablePermanent!['Hours'].length, (index) {
              final hour = _timetablePermanent!['Hours'][index];
              final matchingHour = day['Atoms'].firstWhere(
                (h) => h['HourId'] == hour['Id'],
                orElse: () => null,
              );
              return matchingHour;
            }),
        ];
        _idMapsPermanent = {
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
              for (final subject in _timetablePermanent![category])
                subject['Id']: [subject['Abbrev'], subject['Name']],
            },
        };
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
        Row(
          children: [
            for (final (index, day) in _timetableParsed.indexed)
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.dayNames
                            .split(' ')[index],
                      ),
                    ),
                    for (final hour in day)
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceDim,
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            _idMaps?['Subjects']?[hour?['SubjectId']]?[0] ??
                                'Error',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        Row(
          children: [
            for (final (index, day) in _timetablePermanentParsed.indexed)
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.dayNames
                            .split(' ')[index],
                      ),
                    ),
                    for (final hour in day)
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceDim,
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            _idMapsPermanent?['Subjects']?[hour?['SubjectId']]?[0] ??
                                'Error',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
