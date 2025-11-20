import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? const String.fromEnvironment(
          'BUDGY_API_BASE_URL',
          // 10.0.2.2 points to the host machine when using Android emulator
          defaultValue: 'http://localhost:8080',
        );

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path, [Map<String, dynamic>? queryParameters]) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
  }

  Future<Map<String, String>> defaultHeaders() async {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final headers = await defaultHeaders();
    final uri = _uri(path, query);
    final response = await _client.get(uri, headers: headers);
    _throwIfError(response);
    return response;
  }

  Future<http.Response> post(String path, {Object? body}) async {
    final headers = await defaultHeaders();
    final uri = _uri(path);
    final response = await _client.post(uri, headers: headers, body: body == null ? null : jsonEncode(body));
    _throwIfError(response);
    return response;
  }

  Future<http.Response> put(String path, {Object? body}) async {
    final headers = await defaultHeaders();
    final uri = _uri(path);
    final response = await _client.put(uri, headers: headers, body: body == null ? null : jsonEncode(body));
    _throwIfError(response);
    return response;
  }

  Future<http.Response> delete(String path) async {
    final headers = await defaultHeaders();
    final uri = _uri(path);
    final response = await _client.delete(uri, headers: headers);
    _throwIfError(response);
    return response;
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, body: $body)';
}


