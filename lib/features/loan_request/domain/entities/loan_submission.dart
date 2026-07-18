import '../../../equipment/domain/entities/device.dart';

/// The exhaustive lifecycle state of a persisted loan submission.
enum SubmissionState {
  /// Saved offline and awaiting an explicit retry.
  pending,

  /// A guarded POST is currently in flight.
  sending,

  /// A POST was sent but its outcome could not be confirmed.
  unknownOutcome,

  /// The remote service confirmed creation.
  succeeded,
}

/// A persisted loan submission with its immutable payload and remote outcome.
final class LoanSubmission {
  /// Creates a submission record.
  const LoanSubmission({
    required this.localId,
    required this.idempotencyKey,
    required this.device,
    required this.payload,
    required this.state,
    required this.attemptCount,
    required this.createdAt,
    this.lastAttemptAt,
    this.completedAt,
    this.remoteId,
    this.remoteCreatedAt,
    this.lastError,
  });

  /// The stable local identifier.
  final String localId;

  /// The stable idempotency key preserved across retries.
  final String idempotencyKey;

  /// The device snapshot captured when the request was made.
  final Device device;

  /// The exact immutable remote payload.
  final Map<String, Object?> payload;

  /// The current lifecycle state.
  final SubmissionState state;

  /// The number of POST attempts made so far.
  final int attemptCount;

  /// When the submission was first created.
  final DateTime createdAt;

  /// When the most recent attempt started.
  final DateTime? lastAttemptAt;

  /// When the submission reached a confirmed success.
  final DateTime? completedAt;

  /// The remote identifier once creation is confirmed.
  final String? remoteId;

  /// The remote creation time once confirmed.
  final DateTime? remoteCreatedAt;

  /// The last error summary shown to the user.
  final String? lastError;

  Map<String, Object?> get _data => switch (payload['data']) {
    final Map<String, Object?> data => data,
    _ => const <String, Object?>{},
  };

  /// The student identifier from the payload.
  String get studentId => _data['studentId']?.toString() ?? '';

  /// The ISO borrow date from the payload.
  String get borrowDate => _data['borrowDate']?.toString() ?? '';

  /// The ISO return date from the payload.
  String get returnDate => _data['returnDate']?.toString() ?? '';

  /// The stated purpose from the payload.
  String get purpose => _data['purpose']?.toString() ?? '';

  /// The deposit from the payload.
  int get deposit => switch (_data['deposit']) {
    final num value => value.toInt(),
    _ => 0,
  };

  /// Returns a copy with the supplied values.
  LoanSubmission copyWith({
    SubmissionState? state,
    int? attemptCount,
    DateTime? lastAttemptAt,
    DateTime? completedAt,
    String? remoteId,
    DateTime? remoteCreatedAt,
    String? lastError,
    bool clearError = false,
  }) => LoanSubmission(
    localId: localId,
    idempotencyKey: idempotencyKey,
    device: device,
    payload: payload,
    state: state ?? this.state,
    attemptCount: attemptCount ?? this.attemptCount,
    createdAt: createdAt,
    lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    completedAt: completedAt ?? this.completedAt,
    remoteId: remoteId ?? this.remoteId,
    remoteCreatedAt: remoteCreatedAt ?? this.remoteCreatedAt,
    lastError: clearError ? null : lastError ?? this.lastError,
  );
}
