import 'package:bakalite/utils.dart';

class Entity({
  final String id = '',
  final String abbrev = '',
  final String name = '',
  final String classId = '',
  final String type = '',
  final String beginTime = '',
  final String endTime = '',
  final String caption = '',
  final int size = -1,
}) {
  factory Entity.parse(Map<String, dynamic> data) {
    return Entity(
      id: safeString(data['Id'], stringify: true),
      abbrev: safeString(data['Abbrev']),
      name: safeString(data['Name']),
      classId: safeString(data['ClassId']),
      type: safeString(data['Type']),
      beginTime: safeString(data['BeginTime']),
      endTime: safeString(data['EndTime']),
      caption: safeString(data['Caption']),
      size: data['Size'] is int ? data['Size'] : -1,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Entity &&
        other.id == id &&
        other.abbrev == abbrev &&
        other.name == name &&
        other.classId == classId &&
        other.type == type &&
        other.beginTime == beginTime &&
        other.endTime == endTime &&
        other.caption == caption &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(
    id,
    abbrev,
    name,
    classId,
    type,
    beginTime,
    endTime,
    caption,
    size,
  );
}
