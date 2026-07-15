/// Supplies the current time so date rules remain deterministic and replaceable.
abstract interface class Clock {
  /// Returns the current local date and time.
  DateTime now();
}

/// Uses the host system clock.
final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
