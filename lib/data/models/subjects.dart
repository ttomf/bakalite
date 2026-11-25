import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';

class Subjects({
  required final Map<String, ({Entity subject, Entity teacher})> subjects,
}) {
  factory Subjects.parse(String string, String endpoint) {
    final data = jsonDecode(string);

    final Map<String, ({Entity subject, Entity teacher})> subjectsParsed = {
      for (final subject in data['Subjects'])
        subject['SubjectID']: (
          subject: Entity.parse({
            'Id': subject['SubjectID'],
            'Name': subject['SubjectName'],
            'Abbrev': subject['SubjectAbbrev'],
          }),
          teacher: Entity.parse({
            'Id': subject['TeacherID'],
            'Name': subject['TeacherName'],
            'Abbrev': subject['TeacherAbbrev'],
          }),
        ),
    };

    return Subjects(subjects: subjectsParsed);
  }
}
