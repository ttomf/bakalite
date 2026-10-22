import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:flutter/material.dart';

class TimetableGrid extends StatelessWidget {
  const TimetableGrid(this.timetable, {super.key});

  final List<List<dynamic>> timetable;

  @override
  Widget build(BuildContext context) {
    print(timetable);
    return Row(
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, day) in timetable.indexed)
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
                for (final (index, day) in timetable.indexed)
                  Expanded(
                    child: Row(
                      children: [
                        for (final hour in day)
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceDim,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                                width: 0.5,
                              ),
                            ),
                            child: hour != null
                                ? hour is List
                                      ? Column(
                                          children: [
                                            for (final subject in hour)
                                              Expanded(
                                                child: SubjectCard(subject),
                                              ),
                                          ],
                                        )
                                      : SubjectCard(hour)
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
    );
  }
}
