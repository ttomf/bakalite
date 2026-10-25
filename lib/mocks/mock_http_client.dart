import 'dart:async';
import 'dart:convert';

import 'package:bakalite/mocks/mock_responses.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    final method = request.method;

    http.Response response = http.Response('{"error":"not_found"}', 404);

    for (final entry in mockResponses.entries) {
      final pattern = RegExp(
        '^${RegExp.escape(entry.key).replaceAllMapped(RegExp(r'%([0-9]+)'), (match) => '([^/]+)')}\$',
      );
      final match = pattern.firstMatch('$method $path');

      if (match != null) {
        final params = match.groups([
          for (var i = 0; i <= match.groupCount; i += 1) i,
        ]);

        response = http.Response.bytes(
          utf8.encode(jsonEncode(entry.value(request, params))),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
    }

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}
