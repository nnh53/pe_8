import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'network_exceptions.dart';

/// Executes JSON requests with centralized status and timeout handling.
final class ApiClient {
  /// Creates a client around an injected HTTP transport.
  ApiClient({
    required http.Client client,
    this.apiKey = '',
    this.timeout = const Duration(seconds: 12),
  }) : _client = client;

  final http.Client _client;

  /// The optional RESTful API dashboard key.
  final String apiKey;

  /// Maximum duration allowed for each request.
  final Duration timeout;

  /// Fetches and decodes a successful JSON response.
  Future<Object?> getJson(Uri uri) async {
    final response = await _client
        .get(uri, headers: _headers())
        .timeout(timeout);
    _requireStatus(response, const {200});
    return jsonDecode(response.body);
  }

  /// Posts a JSON document and decodes a successful response.
  Future<Object?> postJson(Uri uri, Map<String, Object?> body) async {
    final response = await _client
        .post(
          uri,
          headers: _headers(const {
            'Content-Type': 'application/json; charset=UTF-8',
          }),
          body: jsonEncode(body),
        )
        .timeout(timeout);
    _requireStatus(response, const {200, 201});
    return jsonDecode(response.body);
  }

  void _requireStatus(http.Response response, Set<int> accepted) {
    if (!accepted.contains(response.statusCode)) {
      throw HttpStatusException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  Map<String, String> _headers([Map<String, String> additional = const {}]) =>
      <String, String>{
        'Accept': 'application/json',
        if (apiKey.isNotEmpty) 'x-api-key': apiKey,
        ...additional,
      };
}
