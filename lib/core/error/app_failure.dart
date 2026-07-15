/// A user-facing classification of an application failure.
sealed class AppFailure {
  const AppFailure(this.message);

  /// A concise message suitable for presentation.
  final String message;
}

/// A failure caused by unavailable or interrupted transport.
final class TransportFailure extends AppFailure {
  const TransportFailure([
    super.message = 'Unable to reach the service. Check your connection.',
  ]);
}

/// A failure returned by the remote HTTP service.
final class ServerFailure extends AppFailure {
  /// Creates an HTTP failure with a presentation message.
  const ServerFailure({required this.statusCode, required String message})
    : super(message);

  /// The rejected HTTP status code.
  final int statusCode;
}

/// A failure caused by malformed or unsupported response data.
final class DataFailure extends AppFailure {
  const DataFailure([
    super.message = 'The service returned data the app could not read.',
  ]);
}

/// An unexpected failure that does not match a known category.
final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure([
    super.message = 'Something unexpected happened. Please try again.',
  ]);
}
