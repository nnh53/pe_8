import 'package:drift/drift.dart';

/// A persisted loan submission and its remote outcome.
@DataClassName('LoanSubmissionRow')
class LoanSubmissions extends Table {
  /// The stable local identifier.
  TextColumn get localId => text()();

  /// The stable local idempotency key for retries.
  TextColumn get idempotencyKey => text().unique()();

  /// The immutable remote payload encoded as JSON.
  TextColumn get payloadJson => text()();

  /// The serialized device snapshot for offline display.
  TextColumn get deviceSnapshotJson => text()();

  /// The exhaustive submission state stored by its enum name.
  TextColumn get state => text()();

  /// How many POST attempts have been made.
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();

  /// When the submission was first created.
  DateTimeColumn get createdAt => dateTime()();

  /// When the last POST attempt started.
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  /// When the submission reached a terminal success.
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// The remote identifier once creation is confirmed.
  TextColumn get remoteId => text().nullable()();

  /// The remote creation time once confirmed.
  DateTimeColumn get remoteCreatedAt => dateTime().nullable()();

  /// The serialized remote response once confirmed.
  TextColumn get remoteResponseJson => text().nullable()();

  /// The last error summary shown to the user.
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {localId};
}
