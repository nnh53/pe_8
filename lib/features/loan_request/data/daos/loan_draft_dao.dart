import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/tables/loan_drafts.dart';
import '../../../equipment/data/mapping/device_json.dart';
import '../../domain/entities/loan_draft.dart';

part 'loan_draft_dao.g.dart';

/// Reads and writes the singleton loan form draft.
@DriftAccessor(tables: [LoanDrafts])
class LoanDraftDao extends DatabaseAccessor<AppDatabase>
    with _$LoanDraftDaoMixin {
  /// Creates the accessor for [db].
  LoanDraftDao(super.db);

  /// Loads the current draft, or null when none is stored.
  Future<LoanDraft?> loadDraft() async {
    final row = await (select(
      loanDrafts,
    )..where((row) => row.id.equals(0))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    final snapshot = switch (jsonDecode(row.deviceSnapshotJson)) {
      final Map<String, Object?> map => map,
      _ => const <String, Object?>{},
    };
    return LoanDraft(
      device: deviceFromJson(snapshot),
      studentId: row.studentId,
      borrowDate: _parseDate(row.borrowDate),
      returnDate: _parseDate(row.returnDate),
      purpose: row.purpose,
      deposit: row.deposit,
    );
  }

  /// Persists [draft] as the single current draft.
  Future<void> saveDraft(LoanDraft draft, {required DateTime updatedAt}) {
    return into(loanDrafts).insertOnConflictUpdate(
      LoanDraftsCompanion.insert(
        id: const Value(0),
        deviceId: draft.device.id,
        deviceSnapshotJson: jsonEncode(deviceToJson(draft.device)),
        studentId: Value(draft.studentId),
        borrowDate: Value(_formatDate(draft.borrowDate)),
        returnDate: Value(_formatDate(draft.returnDate)),
        purpose: Value(draft.purpose),
        deposit: Value(draft.deposit),
        updatedAt: updatedAt,
      ),
    );
  }

  /// Removes the stored draft.
  Future<void> clearDraft() =>
      (delete(loanDrafts)..where((row) => row.id.equals(0))).go();

  DateTime? _parseDate(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  String? _formatDate(DateTime? value) => value == null
      ? null
      : '${value.year.toString().padLeft(4, '0')}-'
            '${value.month.toString().padLeft(2, '0')}-'
            '${value.day.toString().padLeft(2, '0')}';
}
