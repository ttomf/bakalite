import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';

class Mark({
  required final String markText,
  required final int weight,
  required final Entity subject,
  required final DateTime markDate,
  required final String caption,
  required final String theme,
  final bool changed = false,
});

class Marks({
  required final List<Mark> marks,
  required final Map<Entity, ({String note, List<Mark> marks})> bySubject,
}) {
  factory Marks.parse(String string) {
    final data = jsonDecode(string);
    final List<Mark> marksParsed = [];
    final Map<Entity, ({String note, List<Mark> marks})> marksBySubject = {};

    for (final subject in data?['Subjects'] ?? []) {
      final subjectParsed = Entity.parse(subject['Subject'] ?? {});
      final subjectMarks = [
        for (final mark in subject['Marks'] ?? [])
          Mark(
            markText: safeString(mark['MarkText'], stringify: true, trim: true),
            weight: int.tryParse(mark['Weight'].toString()) ?? 0,
            subject: subjectParsed,
            markDate: parseTime(
              safeString(mark['MarkDate'], def: '0000-01-01'),
            ),
            caption: safeString(mark['Caption'], trim: true),
            theme: safeString(mark['Theme'], trim: true),
          ),
      ];
      subjectMarks.sort((a, b) => b.markDate.compareTo(a.markDate));

      marksParsed.addAll(subjectMarks);
      marksBySubject[subjectParsed] = (
        marks: subjectMarks,
        note: safeString(subject['SubjectNote'], trim: true),
      );
    }
    marksParsed.sort((a, b) => b.markDate.compareTo(a.markDate));

    return Marks(marks: marksParsed, bySubject: marksBySubject);
  }
}
