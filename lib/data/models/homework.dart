import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';

class HomeworkItem({
  required final Entity subject,
  required final String content,
  required final DateTime dateStart,
  required final DateTime dateEnd,
  required final bool closed,
  required var bool finished,
  required final String id,
  required final List<Entity> attachments,
}) implements Comparable<HomeworkItem> {
  @override
  int compareTo(HomeworkItem other) {
    final nowDay = DateUtils.dateOnly(DateTime.now());

    final aExpired = DateUtils.dateOnly(dateEnd).isBefore(nowDay);
    final bExpired = DateUtils.dateOnly(other.dateEnd).isBefore(nowDay);

    if (closed != other.closed) return closed ? 1 : -1;
    if (closed && other.closed) return other.dateEnd.compareTo(dateEnd);
    if (aExpired != bExpired) return aExpired ? 1 : -1;
    if (finished != other.finished) return finished ? 1 : -1;

    final dateComparison = aExpired
        ? other.dateEnd.compareTo(dateEnd)
        : dateEnd.compareTo(other.dateEnd);
    if (dateComparison != 0) {
      return dateComparison;
    }

    return id.compareTo(other.id);
  }
}

class Homework({required var List<HomeworkItem> homework}) {
  factory Homework.parse(String string, String endpoint) {
    final data = jsonDecode(string);

    final List<HomeworkItem> homeworkParsed = [
      for (final homework in data?['Homeworks'] ?? [])
        HomeworkItem(
          subject: Entity.parse(homework['Subject'] ?? {}),
          content: safeString(homework['Content'], trim: true),
          dateStart: parseTime(
            safeString(homework['DateStart'], def: '0000-01-01'),
          ),
          dateEnd: parseTime(
            safeString(homework['DateEnd'], def: '0000-01-01'),
          ),
          closed: homework['Closed'] == true || homework['Done'] == true,
          finished: homework['Finished'] == true,
          id: safeString(homework['ID']),
          attachments: [
            for (final attachment in homework['Attachments'] ?? [])
              Entity.parse(attachment ?? {}),
          ],
        ),
    ];

    homeworkParsed.sort();

    return Homework(homework: homeworkParsed);
  }
}
