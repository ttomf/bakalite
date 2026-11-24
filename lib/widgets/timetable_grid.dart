import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class TimetableGrid extends StatelessWidget {
  const TimetableGrid(this.timetable, this.scrollController, {super.key});

  final Timetable timetable;

  static const double containerWidth = 80;
  static const double headerHeight = 40;

  final ScrollController scrollController;

  Widget _buildDay(BuildContext context, TimetableDay day) {
    if (day.dayType != null &&
        day.dayType != 'WorkDay' &&
        day.atoms.isEmpty &&
        !timetable.permanent) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Text(
            day.dayDescription ?? day.dayType ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    bool foundNow = false;
    final Map<String, List<Atom>> atoms = {};
    for (final atom in day.atoms) {
      for (final hour in timetable.hours) {
        if (atom.start < hour.start + hour.duration &&
            hour.start < atom.start + atom.duration) {
          if (DateUtils.isSameDay(atom.date, now) &&
              atom.start < nowMinutes &&
              nowMinutes < (atom.start + atom.duration)) {
            atom.isNow = true;
            foundNow = true;
          }
          (atoms[hour.id] ??= []).add(atom);
        }
      }
    }

    if (!foundNow) {
      for (final hour in atoms.values) {
        for (final atom in hour) {
          if (DateUtils.isSameDay(atom.date, now) &&
              (atom.start - 30) < nowMinutes &&
              nowMinutes < (atom.start + atom.duration)) {
            atom.isNow = true;
          }
        }
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final hour in timetable.hours)
          Container(
            width: containerWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceDim,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                for (final atom in atoms[hour.id] ?? const <Atom>[])
                  Expanded(child: SubjectCard(atom)),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: headerHeight),
              for (final (index, day) in timetable.timetable.indexed)
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
                            if (day.date != null && !timetable.permanent)
                              Text(
                                DateFormat('d. M.').format(day.date!),
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
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (final hour in timetable.hours)
                        Container(
                          width: containerWidth,
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
                            children: [
                              Text(
                                hour.caption,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              Text(
                                '${hour.beginTime} – ${hour.endTime}',
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
                  for (final day in timetable.timetable)
                    Expanded(child: _buildDay(context, day)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
