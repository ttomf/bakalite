import 'package:bakalite/api.dart';
import 'package:test/test.dart';

void main() {
  group("API tests", () {
    final api = BakalariAPI();

    test("getSchools test", () async {
      final schools = await api.getSchools();
      expect(schools, isA<Map>());
    });

    test("getSchoolsIn test", () async {
      final schools = await api.getSchoolsIn("Praha");
      expect(schools, isA<Map>());
    });
  });
}
