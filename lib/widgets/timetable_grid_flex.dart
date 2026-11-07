import 'dart:math';

import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableGridFlex extends StatelessWidget {
  const TimetableGridFlex(
    this.timetable,
    this.hours,
    this.scrollController, {
    super.key,
  });

  final List<Map<String, dynamic>> timetable;
  final List<dynamic> hours;

  static const double pixelsPerMinute = 1.8;
  static const double headerHeight = 40;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final timelineStart = hours.first['Start'];
    final timelineEnd = hours.last['Start'] + hours.last['Duration'];
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
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                  child: SizedBox(
                    height: headerHeight,
                    width: (timelineEnd - timelineStart) * pixelsPerMinute,
                    child: Stack(
                      children: [
                        for (final hour in hours)
                          Positioned(
                            left:
                                (hour['Start'] - hours.first['Start']) *
                                pixelsPerMinute,
                            width: hour['Duration'] * pixelsPerMinute,
                            child: Container(
                              height: headerHeight,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    hour['Caption'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        '${hour['BeginTime']} – ${hour['EndTime']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                for (final day in timetable)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final List<Map<String, dynamic>> atoms = [];
                        final List atomsToAdd = [...day['Atoms']];
                        int lane = 0;

                        while (atomsToAdd.isNotEmpty) {
                          final Set seen = {};
                          final List<Map<String, dynamic>> currentAtoms = [];

                          atomsToAdd.removeWhere((hour) {
                            if (hour == null ||
                                hour['Start'] == null ||
                                hour['Duration'] == null) {
                              return true;
                            }
                            final start = hour['Start'];
                            final duration = hour['Duration'];
                            if ((hour['Change']?['Start'] != null) &&
                                (hour['Change']?['Duration'] != null) &&
                                !seen.add(
                                  '${hour['Change']?['Start']}_${hour['Change']?['Duration']}',
                                )) {
                              return true;
                            }

                            if (currentAtoms.any(
                              (atom) =>
                                  start < atom['Start'] + atom['Duration'] &&
                                  atom['Start'] < start + duration,
                            )) {
                              return false;
                            }

                            currentAtoms.add({...hour, 'Lane': lane});
                            return true;
                          });

                          atoms.addAll(currentAtoms);
                          lane++;
                        }

                        for (final hour in atoms) {
                          int maxLane = hour['Lane'];
                          for (final atom in atoms) {
                            if (hour != atom &&
                                hour['Start'] <
                                    atom['Start'] + atom['Duration'] &&
                                atom['Start'] <
                                    hour['Start'] + hour['Duration']) {
                              maxLane = max(maxLane, atom['Lane']);
                            }
                          }
                          hour['MaxLane'] = maxLane;
                        }

                        return SizedBox(
                          width:
                              (timelineEnd - timelineStart) * pixelsPerMinute,
                          child:
                              (day['DayType'] == null ||
                                  day['DayType'] == 'WorkDay')
                              ? Stack(
                                  children: [
                                    for (final hour in atoms)
                                      Positioned(
                                        left:
                                            (hour['Start'] - timelineStart) *
                                            pixelsPerMinute,
                                        width:
                                            hour['Duration'] * pixelsPerMinute,
                                        top:
                                            hour['Lane'] *
                                            (constraints.maxHeight /
                                                (hour['MaxLane'] + 1)),
                                        bottom:
                                            (hour['MaxLane'] - hour['Lane']) *
                                            (constraints.maxHeight /
                                                (hour['MaxLane'] + 1)),
                                        child: SubjectCard(hour),
                                      ),
                                  ],
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day['DayDescription'] ??
                                          day['DayType'] ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                    ),
                                  ),
                                ),
                        );
                      },
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
