import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class TimetableGridFlex extends StatelessWidget {
  const TimetableGridFlex(this.timetable, this.scrollController, {super.key});

  final Timetable timetable;

  static const double pixelsPerMinute = 1.8;
  static const double headerHeight = 40;

  final ScrollController scrollController;

  Widget _buildDay(
    BuildContext context,
    TimetableDay day,
    int timelineStart,
    double timelineWidth,
  ) {
    if (day.dayType != null && day.dayType != 'WorkDay' && day.atoms.isEmpty) {
      return SizedBox(
        width: timelineWidth,
        child: Container(
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
        ),
      );
    }

    final sorted =
        day.atoms.where((a) => a.start >= 0 && a.duration > 0).toList()
          ..sort((a, b) => a.start.compareTo(b.start));

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    bool foundNow = false;
    for (final atom in sorted) {
      if (atom.date?.year == now.year &&
          atom.date?.month == now.month &&
          atom.date?.day == now.day &&
          atom.start < nowMinutes &&
          nowMinutes < (atom.start + atom.duration)) {
        atom.isNow = true;
        foundNow = true;
      }
    }

    if (!foundNow) {
      for (final atom in sorted) {
        if (atom.date?.year == now.year &&
            atom.date?.month == now.month &&
            atom.date?.day == now.day &&
            (atom.start - 30) < nowMinutes &&
            nowMinutes < (atom.start + atom.duration)) {
          atom.isNow = true;
        }
      }
    }

    final List<({Atom atom, int lane, int lanes})> layout = [];
    List<({Atom atom, int lane})> cluster = [];
    final List<int> laneEnds = [];

    for (final atom in sorted) {
      if (laneEnds.isNotEmpty && laneEnds.every((end) => end <= atom.start)) {
        for (final c in cluster) {
          layout.add((atom: c.atom, lane: c.lane, lanes: laneEnds.length));
        }
        cluster = [];
        laneEnds.clear();
      }

      var lane = laneEnds.indexWhere((end) => end <= atom.start);
      if (lane == -1) {
        lane = laneEnds.length;
        laneEnds.add(0);
      }
      laneEnds[lane] = atom.start + atom.duration;
      cluster.add((atom: atom, lane: lane));
    }

    for (final c in cluster) {
      layout.add((atom: c.atom, lane: c.lane, lanes: laneEnds.length));
    }
    cluster = [];
    laneEnds.clear();

    return SizedBox(
      width: timelineWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              for (final item in layout)
                Positioned(
                  left: (item.atom.start - timelineStart) * pixelsPerMinute,
                  width: item.atom.duration * pixelsPerMinute,
                  top: item.lane * constraints.maxHeight / item.lanes,
                  height: constraints.maxHeight / item.lanes,
                  child: SubjectCard(item.atom),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineStart = timetable.hours.first.start;
    final timelineEnd =
        timetable.hours.last.start + timetable.hours.last.duration;
    final timelineWidth = (timelineEnd - timelineStart) * pixelsPerMinute;

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
                            if (day.date != null)
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
                    width: timelineWidth,
                    child: Stack(
                      children: [
                        for (final hour in timetable.hours)
                          Positioned(
                            left:
                                (hour.start - timetable.hours.first.start) *
                                pixelsPerMinute,
                            width: hour.duration * pixelsPerMinute,
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
                                    hour.caption,
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
                                        '${hour.beginTime} – ${hour.endTime}',
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
                for (final day in timetable.timetable)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                      child: _buildDay(
                        context,
                        day,
                        timelineStart,
                        timelineWidth,
                      ),
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
