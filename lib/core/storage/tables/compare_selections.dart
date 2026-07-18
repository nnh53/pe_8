import 'package:drift/drift.dart';

/// Persisted comparison selections limited by the domain module to two rows.
class CompareSelections extends Table {
  /// The selected device identifier.
  TextColumn get deviceId => text()();

  /// The zero-based ordered position, constrained to 0 or 1 by the domain.
  IntColumn get position => integer()();

  /// When the selection was stored.
  DateTimeColumn get selectedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}
