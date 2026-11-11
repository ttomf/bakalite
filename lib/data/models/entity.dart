class Entity({
  final String? id,
  final String? abbrev,
  final String? name,
  final String? classId,
  final String? type,
  final int? size,
}) {
  factory Entity.parse(Map<String, dynamic> data) {
    return Entity(
      id: data['Id'],
      abbrev: data['Abbrev'],
      name: data['Name'],
      classId: data['ClassId'],
      type: data['Type'],
      size: data['Size'],
    );
  }
}
