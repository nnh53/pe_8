import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/tables/loan_submissions.dart';
import '../../../equipment/data/mapping/device_json.dart';
import '../../domain/entities/loan_submission.dart';

part 'loan_submission_dao.g.dart';

/// Reads and writes persisted loan submissions.
@DriftAccessor(tables: [LoanSubmissions])
class LoanSubmissionDao extends DatabaseAccessor<AppDatabase>
    with _$LoanSubmissionDaoMixin {
  /// Creates the accessor for [db].
  LoanSubmissionDao(super.db);

  /// Loads all submissions, newest first.
  Future<List<LoanSubmission>> loadAll() async {
    final query = select(loanSubmissions)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  /// Counts submissions that still require attention.
  Future<int> countUnresolved() async {
    final rows = await loadAll();
    return rows.where((s) => s.state != SubmissionState.succeeded).length;
  }

  /// Loads one submission by its local identifier.
  Future<LoanSubmission?> findByLocalId(String localId) async {
    final row = await (select(
      loanSubmissions,
    )..where((row) => row.localId.equals(localId))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  /// Inserts or replaces [submission].
  Future<void> upsert(LoanSubmission submission) {
    return into(loanSubmissions).insertOnConflictUpdate(
      LoanSubmissionsCompanion.insert(
        localId: submission.localId,
        idempotencyKey: submission.idempotencyKey,
        payloadJson: jsonEncode(submission.payload),
        deviceSnapshotJson: jsonEncode(deviceToJson(submission.device)),
        state: submission.state.name,
        attemptCount: Value(submission.attemptCount),
        createdAt: submission.createdAt,
        lastAttemptAt: Value(submission.lastAttemptAt),
        completedAt: Value(submission.completedAt),
        remoteId: Value(submission.remoteId),
        remoteCreatedAt: Value(submission.remoteCreatedAt),
        remoteResponseJson: const Value.absent(),
        lastError: Value(submission.lastError),
      ),
    );
  }

  LoanSubmission _toDomain(LoanSubmissionRow row) {
    final payload = switch (jsonDecode(row.payloadJson)) {
      final Map<String, Object?> map => map,
      _ => const <String, Object?>{},
    };
    final snapshot = switch (jsonDecode(row.deviceSnapshotJson)) {
      final Map<String, Object?> map => map,
      _ => const <String, Object?>{},
    };
    return LoanSubmission(
      localId: row.localId,
      idempotencyKey: row.idempotencyKey,
      device: deviceFromJson(snapshot),
      payload: payload,
      state: _stateFromName(row.state),
      attemptCount: row.attemptCount,
      createdAt: row.createdAt,
      lastAttemptAt: row.lastAttemptAt,
      completedAt: row.completedAt,
      remoteId: row.remoteId,
      remoteCreatedAt: row.remoteCreatedAt,
      lastError: row.lastError,
    );
  }

  SubmissionState _stateFromName(String name) {
    for (final value in SubmissionState.values) {
      if (value.name == name) {
        return value;
      }
    }
    return SubmissionState.pending;
  }
}
