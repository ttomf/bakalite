import 'dart:math' as math;

import 'package:bakalite/config.dart';
import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/date_selector.dart';
import 'package:bakalite/widgets/timetable_grid.dart';
import 'package:bakalite/widgets/timetable_grid_flex.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  double? _scrollOffset;
  DateTime changeFrom = addDays(DateTime.now(), 0);
  DateTime changeTo = addDays(DateTime.now(), 1);

  late final ScrollController _actualScrollController = _createScrollController(
    () => Data.timetable.actual?.hours,
  );
  late final ScrollController _permScrollController = _createScrollController(
    () => Data.timetable.perm?.hours,
  );

  ScrollController _createScrollController(List<dynamic>? Function() hours) {
    return ScrollController(
      keepScrollOffset: false,
      onAttach: (position) {
        position.addListener(() => _scrollOffset = position.pixels);
        position.correctPixels(
          _scrollOffset ??
              math.max(
                0,
                _lessonCenter(hours()) - MediaQuery.sizeOf(context).width / 2,
              ),
        );
      },
    );
  }

  double _lessonCenter(List<dynamic>? hours) {
    if (hours == null || hours.isEmpty) return 0;

    final now = DateTime.now();
    final minutes = now.hour * 60 + now.minute;
    var index = hours.indexWhere(
      (hour) => minutes < hour.start + hour.duration,
    );
    if (index < 0) index = hours.length - 1;

    if (Config.flexTimetable.value) {
      return (hours[index].start -
              hours.first.start +
              hours[index].duration / 2) *
          TimetableGridFlex.pixelsPerMinute;
    } else {
      return (index + 0.5) * TimetableGrid.containerWidth;
    }
  }

  @override
  void initState() {
    Data.timetableDate = weekStart(DateTime.now());
    super.initState();
    Data.loadTimetable();
    if (weekStart(changeTo) != Data.timetableDate) {
      Data.loadTimetable(customDate: changeTo);
    }
  }

  @override
  void dispose() {
    _actualScrollController.dispose();
    _permScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timetableGrid = Config.flexTimetable.value
        ? TimetableGridFlex.new
        : TimetableGrid.new;

    return ListenableBuilder(
      listenable: Data.timetableRes,
      builder: (context, _) {
        final actualEndpoint =
            'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(Data.timetableDate)}';
        final changeFromEndpoint =
            'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(weekStart(changeFrom))}';
        final changeToEndpoint =
            'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(weekStart(changeTo))}';

        return Wrapper(
          title: AppLocalizations.of(context)!.timetable,
          subtitle: getCacheInfo(
            context,
            Data.timetableRes.cacheTimestamp[actualEndpoint] ??
                Data.timetableRes.cacheTimestamp['timetable/permanent'],
            Data.timetableRes.loaded[actualEndpoint] != null &&
                Data.timetableRes.loaded['timetable/permanent'] != null &&
                Data.timetableRes.loaded[changeFromEndpoint] != null &&
                Data.timetableRes.loaded[changeToEndpoint] != null,
            Data.timetableRes.error[actualEndpoint] != null ||
                Data.timetableRes.error['timetable/permanent'] != null ||
                Data.timetableRes.error[changeFromEndpoint] != null ||
                Data.timetableRes.error[changeToEndpoint] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.actual,
            AppLocalizations.of(context)!.permanent,
            AppLocalizations.of(context)!.bagChanges,
          ],
          onRefresh: () {
            Data.loadTimetable(force: true);
          },
          children: [
            Column(
              children: [
                DateSelector(
                  date: Data.timetableDate,
                  label: switch (Config.relativeDateLabels.value
                      ? daysBetween(
                          Data.timetableDate,
                          weekStart(DateTime.now()),
                        )
                      : null) {
                    -7 => AppLocalizations.of(context)!.previousWeek,
                    0 => AppLocalizations.of(context)!.thisWeek,
                    7 => AppLocalizations.of(context)!.nextWeek,
                    _ =>
                      '${DateFormat('d. M. yyyy').format(Data.timetableDate)} – ${DateFormat('d. M. yyyy').format(addDays(Data.timetableDate, 4))}',
                  },
                  onChanged: (date) {
                    Data.timetableDate = weekStart(date);
                    Data.loadTimetable();
                  },
                  step: 7,
                ),
                Expanded(
                  child: Data.timetable.actual != null
                      ? timetableGrid(
                          Data.timetable.actual!,
                          _actualScrollController,
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
            Data.timetable.perm != null
                ? timetableGrid(
                    Data.timetable.perm!,
                    _permScrollController,
                    permanent: true,
                  )
                : const Center(child: CircularProgressIndicator()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(8),
                    2: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sourceDay,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(),
                        DateSelector(
                          date: changeFrom,
                          label: switch (Config.relativeDateLabels.value
                              ? daysBetween(changeFrom, DateTime.now())
                              : null) {
                            -1 => AppLocalizations.of(context)!.yesterday,
                            0 => AppLocalizations.of(context)!.today,
                            1 => AppLocalizations.of(context)!.tomorrow,
                            _ => DateFormat(
                              'EE d. M. yyyy',
                              AppLocalizations.of(context)!.localeName,
                            ).format(changeFrom),
                          },
                          initialDate: DateTime.now(),
                          onChanged: (date) {
                            setState(() {
                              changeFrom = date;
                              Data.loadTimetable(customDate: date);
                            });
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.targetDay,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(),
                        DateSelector(
                          date: changeTo,
                          label: switch (Config.relativeDateLabels.value
                              ? daysBetween(changeTo, DateTime.now())
                              : null) {
                            -1 => AppLocalizations.of(context)!.yesterday,
                            0 => AppLocalizations.of(context)!.today,
                            1 => AppLocalizations.of(context)!.tomorrow,
                            _ => DateFormat(
                              'EE d. M. yyyy',
                              AppLocalizations.of(context)!.localeName,
                            ).format(changeTo),
                          },
                          initialDate: addDays(DateTime.now(), 1),
                          onChanged: (date) {
                            setState(() {
                              changeTo = date;
                              Data.loadTimetable(customDate: date);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Data.timetable.byDate[changeFrom] != null &&
                        Data.timetable.byDate[changeTo] != null
                    ? IntrinsicHeight(
                        child: Builder(
                          builder: (context) {
                            final from =
                                Data.timetable.byDate[changeFrom]?.atoms
                                    .map((e) => e.subject?.name)
                                    .whereType<String>()
                                    .toSet() ??
                                {};
                            final to =
                                Data.timetable.byDate[changeTo]?.atoms
                                    .map((e) => e.subject?.name)
                                    .whereType<String>()
                                    .toSet() ??
                                {};

                            final list = (
                              from: [
                                ...from.intersection(to),
                                ...from.difference(to).map((e) => '- $e'),
                              ]..sort(),
                              to: [
                                ...from.intersection(to),
                                ...to.difference(from).map((e) => '+ $e'),
                              ]..sort(),
                            );

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (final subject in list.from)
                                      Text(
                                        subject,
                                        style: subject.startsWith('- ')
                                            ? const TextStyle(color: Colors.red)
                                            : null,
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1.5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final subject in list.to)
                                      Text(
                                        subject,
                                        style: subject.startsWith('+ ')
                                            ? const TextStyle(
                                                color: Colors.green,
                                              )
                                            : null,
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Data.timetableRes.loaded[changeFromEndpoint] == null ||
                          Data.timetableRes.loaded[changeToEndpoint] == null
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(),
              ],
            ),
          ],
        );
      },
    );
  }
}
