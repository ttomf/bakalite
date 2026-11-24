import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';

class TimeInterval({
  required final DateTime start,
  required final DateTime end,
  required final bool oneDay,
  required final bool wholeDay,
}) {
  factory TimeInterval.parse(List times) {
    DateTime? timeStart;
    DateTime? timeEnd;

    for (final time in times) {
      if (time['StartTime'] != null &&
          (timeStart == null ||
              parseTime(time['StartTime']).isBefore(timeStart))) {
        timeStart = parseTime(time['StartTime']);
      }
      if (time['EndTime'] != null &&
          (timeEnd == null || parseTime(time['EndTime']).isAfter(timeEnd))) {
        timeEnd = parseTime(time['EndTime']);
      }
    }

    return TimeInterval(
      start: timeStart ?? parseTime('0000-01-01'),
      end: timeEnd ?? parseTime('0000-01-01'),
      oneDay:
          timeStart != null &&
          timeEnd != null &&
          times.length == 1 &&
          DateUtils.dateOnly(timeStart) == DateUtils.dateOnly(timeEnd),
      wholeDay: times.every((time) => time['WholeDay']),
    );
  }
}

class Event({
  required final String title,
  required final String description,
  required final Entity eventType,
  required final TimeInterval interval,
  required final List<Entity> teachers,
  required final List<Entity> classes,
  required final List<Entity> rooms,
});

class Events({required final List<Event> events}) {
  factory Events.parse(String string, String endpoint) {
    final data = jsonDecode(string);

    final List<Event> eventsParsed = [
      for (final event in data['Events'] ?? [])
        Event(
          title: safeString(event['Title'], trim: true),
          description: safeString(event['Description'], trim: true),
          eventType: Entity.parse(event['EventType'] ?? {}),
          interval: TimeInterval.parse(event['Times']),
          teachers: [
            for (final entity in event['Teachers'] ?? [])
              Entity.parse(entity ?? {}),
          ],
          classes: [
            for (final entity in event['Classes'] ?? [])
              Entity.parse(entity ?? {}),
          ],
          rooms: [
            for (final entity in event['Rooms'] ?? [])
              Entity.parse(entity ?? {}),
          ],
        ),
    ];

    eventsParsed.sort((a, b) => a.interval.start.compareTo(b.interval.start));

    return Events(events: eventsParsed);
  }
}
