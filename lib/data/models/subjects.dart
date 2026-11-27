import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';

class Subjects({
  required final Map<String, ({Entity subject, List<Entity> teachers})>
  subjects,
}) {
  factory Subjects.parse(String string, String endpoint) {
    final data = jsonDecode(string);
    final Map<String, ({Entity subject, List<Entity> teachers})>
    subjectsParsed = {};

    for (final subject in data['Subjects']) {
      if (subjectsParsed.containsKey(subject['SubjectID'])) {
        subjectsParsed[subject['SubjectID']]!.teachers.add(
          Entity.parse({
            'Id': subject['TeacherID'],
            'Name': subject['TeacherName'],
            'Abbrev': subject['TeacherAbbrev'],
          }),
        );
      } else {
        subjectsParsed[subject['SubjectID']] = (
          subject: Entity.parse({
            'Id': subject['SubjectID'],
            'Name': subject['SubjectName'],
            'Abbrev': subject['SubjectAbbrev'],
          }),
          teachers: [
            Entity.parse({
              'Id': subject['TeacherID'],
              'Name': subject['TeacherName'],
              'Abbrev': subject['TeacherAbbrev'],
            }),
          ],
        );
      }
    }

    return Subjects(subjects: subjectsParsed);
  }
}
