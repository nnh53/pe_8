/// A success-or-failure result that keeps expected errors out of widgets.
sealed class Result<T, E> {
  const Result();
}

/// A successful result value.
final class Success<T, E> extends Result<T, E> {
  const Success(this.value);

  /// The successful value.
  final T value;
}

/// A failed result value.
final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);

  /// The classified failure.
  final E error;
}
