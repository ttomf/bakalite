import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableGrid extends StatelessWidget {
  const TimetableGrid(this.timetable, this.hours, {super.key});

  final List<Map<String, dynamic>> timetable;
  final List<dynamic> hours;

  static const double containerWidth = 80;
  static const double headerHeight = 40;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: headerHeight),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dayNamesShort
                                  .split(' ')[index],
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                            if (day['Date'] != null)
                              Text(
                                DateFormat('d. M.').format(day['Date']),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                          ],
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
                Row(
                  children: [
                    for (final hour in hours)
                      Container(
                        width: containerWidth,
                        height: headerHeight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              hour['Caption'],
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                            Text(
                              '${hour['BeginTime']} – ${hour['EndTime']}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                for (final (index, day) in timetable.indexed)
                  Expanded(
                    child: Row(
                      children: [
                        for (final hour in day['Atoms'])
                          Container(
                            width: containerWidth,
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
