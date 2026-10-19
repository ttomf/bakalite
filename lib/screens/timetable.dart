import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/widgets/subject_card.dart';
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
        print(_timetableParsed[0]);
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
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, day) in _timetableParsed.indexed)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 0.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.dayNamesShort
                                  .split(' ')[index],
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (index, day) in _timetableParsed.indexed)
                      Expanded(
                        child: Row(
                          children: [
                            for (final hour in day)
                              Container(
                                constraints: const BoxConstraints(minWidth: 70),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceDim,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 0.5,
                                  ),
                                ),
                                child: hour != null
                                    ? SubjectCard(
                                        subject:
                                            _idMaps?['Subjects']?[hour['SubjectId']]?[0] ??
                                            'Error',
                                        teacher:
                                            _idMaps?['Teachers']?[hour['TeacherId']]?[0] ??
                                            'Error',
                                        room:
                                            _idMaps?['Rooms']?[hour['RoomId']]?[0] ??
                                            'Error',
                                        changeType:
                                            hour['Change']?['ChangeType'],
                                        change: hour['Change']?['Description'],
                                      )
                                    : null,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Text('todo'),
      ],
    );
  }
}
