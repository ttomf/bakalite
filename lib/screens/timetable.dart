import 'dart:math' as math;

import 'package:bakalite/config.dart';
import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/timetable_grid.dart';
import 'package:bakalite/widgets/timetable_grid_flex.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  double? _scrollOffset;

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

  DateTime _addDays(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }

  @override
  void initState() {
    Data.timetableDate = weekStart(DateTime.now());
    super.initState();
    Data.loadTimetable();
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

        return Wrapper(
          title: AppLocalizations.of(context)!.timetable,
          subtitle: getCacheInfo(
            context,
            Data.timetableRes.cacheTimestamp[actualEndpoint] ??
                Data.timetableRes.cacheTimestamp['timetable/permanent'],
            Data.timetableRes.loaded[actualEndpoint] != null &&
                Data.timetableRes.loaded['timetable/permanent'] != null,
            Data.timetableRes.error[actualEndpoint] != null ||
                Data.timetableRes.error['timetable/permanent'] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.actual,
            AppLocalizations.of(context)!.permanent,
          ],
          onRefresh: () {
            Data.loadTimetable(force: true);
          },
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        Data.timetableDate = _addDays(Data.timetableDate, -7);
                        Data.loadTimetable();
                      },
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text(switch (Config.relativeDateLabels.value
                            ? daysBetween(
                                Data.timetableDate,
                                weekStart(DateTime.now()),
                              )
                            : null) {
                          -7 => AppLocalizations.of(context)!.previousWeek,
                          0 => AppLocalizations.of(context)!.thisWeek,
                          7 => AppLocalizations.of(context)!.nextWeek,
                          _ =>
                            '${DateFormat('d. M. yyyy').format(Data.timetableDate)} – ${DateFormat('d. M. yyyy').format(_addDays(Data.timetableDate, 4))}',
                        }),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: Data.timetableDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365 * 2),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 2),
                            ),
                          );
                          if (date == null || !mounted) return;
                          Data.timetableDate = weekStart(date);
                          Data.loadTimetable();
                        },
                        onLongPress: () {
                          Data.timetableDate = weekStart(DateTime.now());
                          Data.loadTimetable();
                        },
                      ),
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        Data.timetableDate = _addDays(Data.timetableDate, 7);
                        Data.loadTimetable();
                      },
                    ),
                  ],
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
                ? timetableGrid(Data.timetable.perm!, _permScrollController)
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
