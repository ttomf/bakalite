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
  List<List<Map<String, dynamic>?>> _timetableParsed = [[], [], [], [], []];
  Map<String, Map<String?, List<String>>> _idMaps = {};
  Map<String, dynamic>? _timetablePerm;
  List<List<Map<String, dynamic>?>> _timetablePermParsed = [[], [], [], [], []];
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
              };
            }),
        ];
        // TODO: permanent timetable
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
                                width: 70,
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
                                child: hour != null ? SubjectCard(hour) : null,
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
