import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';

class Change({
  required final String changeType,
  required final String typeAbbrev,
  required final String typeName,
  required final String description,
  required final int? start,
  required final int? duration,
}) {
  factory Change.parse(Map<String, dynamic> data) {
    return Change(
      changeType: safeString(data['ChangeType']),
      typeAbbrev: safeString(data['TypeAbbrev']),
      typeName: safeString(data['TypeName']),
      description: safeString(data['Description']),
      start: data['Start'],
      duration: data['Duration'],
    );
  }
}

class Atom({
  required final Entity? subject,
  required final Entity? teacher,
  required final Entity? room,
  required final List<Entity> groups,
  required final int start,
  required final int duration,
  required final String hourId,
  required final Change? change,
  required final String theme,
  required final List<Entity> homework,
  required final bool permanent,
  final DateTime? date,
  var bool isNow = false,
});

class TimetableDay({
  required final DateTime? date,
  required final String? dayType,
  required final String? dayDescription,
  required final List<Atom> atoms,
});

class Timetable({
  required final List<TimetableDay> timetable,
  required final List<Entity> hours,
  required final bool permanent,
}) {
  static final Map<DateTime, TimetableDay> byDate = {};

  static List<Atom> parseAtoms(
    List atoms,
    Map<String, Map<String, Entity>> idMaps,
    bool perm, {
    DateTime? date,
  }) {
    final List<Atom> res = [];
    final Set<String> seenChanges = {};

    for (final hour in atoms) {
      final change = hour['Change'] != null
          ? Change.parse(hour['Change'])
          : null;

      if (change != null && change.start != null && change.duration != null) {
        final key = [
          change.changeType,
          change.typeAbbrev,
          change.description,
          change.start,
          change.duration,
          hour['SubjectId'],
          hour['TeacherId'],
          hour['RoomId'],
        ].join('|');
        if (!seenChanges.add(key)) {
          continue;
        }
      }

      res.add(
        Atom(
          subject: idMaps['Subjects']?[hour['SubjectId']],
          teacher: idMaps['Teachers']?[hour['TeacherId']],
          room: idMaps['Rooms']?[hour['RoomId']],
          groups:
              (hour['GroupIds'] as List<dynamic>?)
                  ?.map((id) => idMaps['Groups']?[id])
                  .whereType<Entity>()
                  .toList() ??
              [],
          start: change?.start ?? hour['Start'],
          duration: change?.duration ?? hour['Duration'],
          change: change,
          hourId: safeString(hour['HourId'], stringify: true),
          theme: hour['Theme'] ?? '',
          homework: [
            if (!perm)
              for (final homework in hour['Homeworks'] ?? [])
                Entity.parse(homework ?? {}),
          ],
          permanent: perm,
          date: date,
        ),
      );
    }

    return res;
  }

  factory Timetable.parse(String string, String endpoint) {
    final perm = endpoint == 'timetable/permanent';
    final data = jsonDecode(string);

    final idMaps = {
      for (final category in [
        'Classes',
        'Groups',
        'Subjects',
        'Teachers',
        'Rooms',
        'Cycles',
      ])
        category: {
          for (final entity in data?[category] ?? [])
            entity['Id'].toString(): Entity.parse(entity),
        },
    };
    final List<TimetableDay> timetableParsed = [];

    for (final day in data?['Days'] ?? []) {
      final date = day['Date'] != null
          ? DateUtils.dateOnly(parseTime(safeString(day['Date'])))
          : null;
      final timetableDay = TimetableDay(
        date: date,
        dayType: day['DayType']?.trim(),
        dayDescription: day['DayDescription']?.trim(),
        atoms: parseAtoms(day['Atoms'] ?? [], idMaps, perm, date: date),
      );

      timetableParsed.add(timetableDay);
      if (date != null && !perm) byDate[date] = timetableDay;
    }
    final List<Entity> hoursParsed = [
      for (final hour in data?['Hours'] ?? []) Entity.parse(hour),
    ];

    return Timetable(
      timetable: timetableParsed,
      hours: hoursParsed,
      permanent: perm,
    );
  }
}
