import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_storage.dart';

class ApiException implements Exception {
  const ApiException(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required TokenStorage tokens,
    http.Client? client,
  }) : _tokens = tokens,
       _client = client ?? http.Client();

  final String baseUrl;
  final TokenStorage _tokens;
  final http.Client _client;

  Future<Map<String, Object?>> get(String path) => _request('GET', path);
  Future<Map<String, Object?>> post(
    String path, {
    Map<String, Object?>? body,
  }) => _request('POST', path, body: body);
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
  }) => _request('PUT', path, body: body);

  Future<void> delete(String path) async {
    await _request('DELETE', path, allowEmpty: true);
  }

  Future<Map<String, Object?>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool allowEmpty = false,
  }) async {
    final token = await _tokens.read();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    final request = http.Request(method, Uri.parse('$baseUrl$path'))
      ..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final decoded = response.body.isEmpty
          ? null
          : jsonDecode(response.body) as Map<String, Object?>;
      throw ApiException(
        decoded?['message'] as String? ?? 'Request failed',
        response.statusCode,
      );
    }
    if (allowEmpty && response.body.isEmpty) return <String, Object?>{};
    return jsonDecode(response.body) as Map<String, Object?>;
  }
}
