import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../network/network_exceptions.dart';
import 'app_failure.dart';

/// Converts infrastructure exceptions into stable application failures.
AppFailure mapFailure(Object error) => switch (error) {
  HttpStatusException exception => _mapHttpFailure(exception),
  TimeoutException() ||
  SocketException() ||
  http.ClientException() => const TransportFailure(),
  FormatException() || ResponseDataException() => const DataFailure(),
  _ => const UnexpectedFailure(),
};

AppFailure _mapHttpFailure(HttpStatusException exception) {
  if (exception.body.toLowerCase().contains('daily request limit')) {
    return ServerFailure(
      statusCode: exception.statusCode,
      message: 'The API daily request limit has been reached.',
    );
  }
  return ServerFailure(
    statusCode: exception.statusCode,
    message: 'Service request failed (${exception.statusCode}).',
  );
}
