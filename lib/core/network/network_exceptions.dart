/// An exception for a rejected HTTP response.
final class HttpStatusException implements Exception {
  const HttpStatusException({required this.statusCode, required this.body});

  /// The HTTP status code.
  final int statusCode;

  /// The response body retained for diagnostics.
  final String body;
}

/// An exception for a structurally invalid successful response.
final class ResponseDataException implements Exception {
  const ResponseDataException(this.message);

  /// A diagnostic description of the invalid response.
  final String message;
}
