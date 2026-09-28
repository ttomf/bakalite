import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions.dart';

class BakalariAPI {
  BakalariAPI({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  static const mainBaseUrl = 'https://sluzby.bakalari.cz/api/v1';
  String? baseUrl;
  String? accessToken;
  String? username;
  String? password;

  Future<Map<String, int>> getSchools() async {
    try {
      final res = await client.get(
        Uri.parse('$mainBaseUrl/municipality'),
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw BakaLiteException(BakaLiteError.http, 'HTTP ${res.statusCode}');
      }

      final json = jsonDecode(res.body);

      if (json is! List) {
        throw const BakaLiteException(
          BakaLiteError.invalidResponse,
          'Expected a JSON list',
        );
      }

      final map = <String, int>{};

      for (final city in json) {
        if (city is! Map<String, dynamic>) {
          throw const BakaLiteException(
            BakaLiteError.invalidResponse,
            'Expected city to be a JSON object',
          );
        }

        map[city['name']] = city['schoolCount'];
      }

      return map;
    } on http.ClientException catch (e) {
      throw BakaLiteException(BakaLiteError.network, e.toString());
    } on FormatException {
      throw const BakaLiteException(
        BakaLiteError.invalidResponse,
        'Invalid JSON',
      );
    }
  }

  Future<Map<String, String>> getSchoolsIn(String city) async {
    try {
      if (city.isEmpty) {
        return {};
      }

      final res = await client.get(
        Uri.parse('$mainBaseUrl/municipality/$city'),
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode == 404) {
        return {};
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw BakaLiteException(BakaLiteError.http, 'HTTP ${res.statusCode}');
      }

      final json = jsonDecode(res.body);

      if (json is! Map) {
        throw const BakaLiteException(
          BakaLiteError.invalidResponse,
          'Expected a JSON dict',
        );
      }

      if (json['schools'] is! List) {
        throw const BakaLiteException(
          BakaLiteError.invalidResponse,
          'Expected schools to be a JSON list',
        );
      }

      final map = <String, String>{};

      for (final school in json['schools']) {
        if (school is! Map<String, dynamic>) {
          throw const BakaLiteException(
            BakaLiteError.invalidResponse,
            'Expected school to be a JSON object',
          );
        }

        map[school['name']] = school['schoolUrl'];
      }

      return map;
    } on http.ClientException catch (e) {
      throw BakaLiteException(BakaLiteError.network, e.toString());
    } on FormatException {
      throw const BakaLiteException(
        BakaLiteError.invalidResponse,
        'Invalid JSON',
      );
    }
  }

  Future<String> login(String user, String pass) async {
    try {
      if (baseUrl?.isEmpty ?? true) {
        throw const BakaLiteException(
          BakaLiteError.invalidInput,
          'Base URL cannot be empty',
        );
      }

      if (user.isEmpty) {
        throw const BakaLiteException(
          BakaLiteError.invalidInput,
          'Username cannot be empty',
        );
      }

      if (pass.isEmpty) {
        throw const BakaLiteException(
          BakaLiteError.invalidInput,
          'Password cannot be empty',
        );
      }

      final res = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': 'ANDR',
          'grant_type': 'password',
          'username': user,
          'password': pass,
        },
      );

      final json = jsonDecode(res.body);

      if (json is! Map) {
        throw const BakaLiteException(
          BakaLiteError.invalidResponse,
          'Expected a JSON dict',
        );
      }

      if (res.statusCode < 200 || res.statusCode >= 300) {
        if (json['error'] == 'invalid_grant') {
          throw const BakaLiteException(BakaLiteError.invalidCredentials);
        }

        throw BakaLiteException(BakaLiteError.http, 'HTTP ${res.statusCode}');
      }

      if (json['access_token'] is! String) {
        throw const BakaLiteException(
          BakaLiteError.invalidResponse,
          'Expected access_token to be a string',
        );
      }

      password = pass;
      username = user;
      accessToken = json['access_token'];

      return json['access_token'];
    } on http.ClientException catch (e) {
      throw BakaLiteException(BakaLiteError.network, e.toString());
    } on FormatException {
      throw const BakaLiteException(
        BakaLiteError.invalidResponse,
        'Invalid JSON (likely an invalid URL)',
      );
    }
  }
}
