import 'dart:convert';

import 'package:bakalite/api.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'api_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  group('API tests', () {
    final client = MockHttpClient();
    api = BakalariAPI(client: client);

    when(
      client.get(
        Uri.parse('https://sluzby.bakalari.cz/api/v1/municipality'),
        headers: {'Accept': 'application/json'},
      ),
    ).thenAnswer(
      (_) async => http.Response('''
        [{"name": "Praha","schoolCount": 4},
        {"name": "Brno","schoolCount": 2}]''', 200),
    );

    when(
      client.get(
        Uri.parse('https://sluzby.bakalari.cz/api/v1/municipality/Praha'),
        headers: {'Accept': 'application/json'},
      ),
    ).thenAnswer(
      (_) async => http.Response('''
        {"name": "Praha", "schools": [
        {"id": "SK00000001", "name": "School One", "schoolUrl": "https://one.school.cz/"},
        {"id": "SK00000002", "name": "School Two", "schoolUrl": "https://two.school.cz"},
        {"id": "SK00000003", "name": "School Three", "schoolUrl": "https://schoolthree.bakalari.cz/bakaweb/"},
        {"id": "SK00000004", "name": "School Four", "schoolUrl": "https://schoolfour.bakalari.cz"}
        ]}''', 200),
    );

    when(
      client.post(
        Uri.parse('https://school.cz/bakaweb/api/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': 'ANDR',
          'grant_type': 'password',
          'username': 'USERNAME',
          'password': 'PASSWORD',
        },
      ),
    ).thenAnswer(
      (_) async => http.Response('''{
        "bak:UserId": "ABC123",
        "access_token": "VERY-LONG-TOKEN",
        "token_type": "Bearer",
        "expires_in": 3600,
        "scope": "offline_access bakalari_api timetable_widget",
        "refresh_token": "EVEN-LONGER-TOKEN",
        "bak:ApiVersion": "3.52.1",
        "bak:AppVersion": "2.2.917.2"
        }''', 200),
    );

    when(
      client.get(
        Uri.parse('https://school.cz/bakaweb/api/3/user'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer VERY-LONG-TOKEN',
        },
      ),
    ).thenAnswer(
      (_) async => http.Response.bytes(
        utf8.encode('''{
      "UserUID":"1234/id",
      "CampaignCategoryCode":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "Class":{
        "Id":"XL",
        "Abbrev":"X.A",
        "Name":"X. A"
      },
      "FullName":"Příjmení Jméno, X.A",
      "SchoolOrganizationName":"school",
      "SchoolType":null,
      "UserType":"parents",
      "UserTypeText":"rodič"
    }'''),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );

    test('getSchools test', () async {
      final schools = await api.getSchools();
      expect(schools, {'Praha': 4, 'Brno': 2});
    });

    test('getSchoolsIn test', () async {
      final schools = await api.getSchoolsIn('Praha');
      expect(schools, {
        'School One': 'https://one.school.cz/',
        'School Two': 'https://two.school.cz',
        'School Three': 'https://schoolthree.bakalari.cz/bakaweb/',
        'School Four': 'https://schoolfour.bakalari.cz',
      });
    });

    api.baseUrl = 'https://school.cz/bakaweb/api';

    test('login test', () async {
      final token = await api.login('USERNAME', 'PASSWORD');
      expect(token, 'VERY-LONG-TOKEN');
      expect(api.accessToken, 'VERY-LONG-TOKEN');
    });

    test('user test', () async {
      final user = await api.fetch('user');
      expect(user['FullName'], 'Příjmení Jméno, X.A');
    });
  });
}
