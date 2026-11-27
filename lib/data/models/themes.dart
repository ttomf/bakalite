import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';

class SubjectTheme({
  required final DateTime date,
  required final String theme,
  required final String note,
  required final String lessonLabel,
});

class Themes({
  required final List<SubjectTheme> themes,
  required final Entity subject,
}) {
  factory Themes.parse(String string, String endpoint) {
    final data = jsonDecode(string);

    final List<SubjectTheme> themesParsed = [
      for (final theme in data['Themes'] ?? [])
        SubjectTheme(
          date: parseTime(safeString(theme['Date'], def: '0000-01-01')),
          theme: safeString(theme['Theme']),
          note: safeString(theme['Note']),
          lessonLabel: safeString(theme['LessonLabel']),
        ),
    ];
    themesParsed.sort((a, b) => b.date.compareTo(a.date));

    return Themes(
      themes: themesParsed,
      subject: Entity.parse(data['Subject'] ?? {}),
    );
  }
}
