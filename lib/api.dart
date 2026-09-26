import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BakalariAPI {
  static const mainBaseUrl = 'https://sluzby.bakalari.cz/api/v1';

  Future<Map<String, int>> getSchools() async {
    try {
      final res = await http.get(
        Uri.parse('$mainBaseUrl/municipality'),
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw HttpException('HTTP ${res.statusCode}');
      }

      final json = jsonDecode(res.body);

      if (json is! List) {
        throw const FormatException('Expected a JSON list');
      }

      final map = <String, int>{};

      for (final city in json) {
        if (city is! Map<String, dynamic>) {
          throw const FormatException('Expected a list of JSON objects');
        }

        map[city['name']] = city['schoolCount'];
      }

      return map;
    } on http.ClientException {
      throw Exception('Network error');
    }
  }

  Future<Map<String, String>> getSchoolsIn(String city) async {
    try {
      if (city.isEmpty) {
        return {};
      }
      final res = await http.get(
        Uri.parse('$mainBaseUrl/municipality/$city'),
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode == 404) {
        return {};
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw HttpException('HTTP ${res.statusCode}');
      }

      final json = jsonDecode(res.body);

      if (json is! Map) {
        throw const FormatException('Expected a JSON dict');
      }

      if (json['schools'] is! List) {
        throw const FormatException('Expected a JSON list');
      }

      final map = <String, String>{};

      for (final school in json['schools']) {
        if (school is! Map<String, dynamic>) {
          throw const FormatException('Expected a list of JSON objects');
        }

        map[school['name']] = school['schoolUrl'];
      }

      return map;
    } on http.ClientException {
      throw Exception('Network error');
    }
  }
}
