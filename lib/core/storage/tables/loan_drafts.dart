import 'package:drift/drift.dart';

/// A singleton in-progress loan form draft.
@DataClassName('LoanDraftRow')
class LoanDrafts extends Table {
  /// The fixed singleton key (always 0).
  IntColumn get id => integer().withDefault(const Constant(0))();

  /// The selected device identifier.
  TextColumn get deviceId => text()();

  /// The serialized device snapshot for safe restoration.
  TextColumn get deviceSnapshotJson => text()();

  /// The entered student identifier.
  TextColumn get studentId => text().withDefault(const Constant(''))();

  /// The chosen borrow date as an ISO date string, when set.
  TextColumn get borrowDate => text().nullable()();

  /// The chosen return date as an ISO date string, when set.
  TextColumn get returnDate => text().nullable()();

  /// The entered purpose.
  TextColumn get purpose => text().withDefault(const Constant(''))();

  /// The derived deposit for the selected device.
  IntColumn get deposit => integer().withDefault(const Constant(0))();

  /// When the draft was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
