import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? timetableData = _timetable;

      if (_timetable == null) {
        timetableData = await api.fetch('timetable/actual');
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
          'Subjects': {
            null: ['', ''],
            for (final subject in _timetable!['Subjects'])
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
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.timetable)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final (index, day) in _timetableParsed.indexed)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceDim,
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
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
          ),
        ),
      ),
    );
  }
}
