import 'package:drift/drift.dart';

/// A cached copy of one normalized device for offline catalogue display.
class CachedDevices extends Table {
  /// The remote device identifier.
  TextColumn get deviceId => text()();

  /// The display name.
  TextColumn get name => text()();

  /// The complete raw attribute map encoded as JSON.
  TextColumn get rawDataJson => text()();

  /// The estimated value in whole cents, when available.
  IntColumn get estimatedValueMinor => integer().nullable()();

  /// The model or release year, when available.
  IntColumn get year => integer().nullable()();

  /// The inferred category stored by its enum name.
  TextColumn get category => text()();

  /// The original zero-based remote position.
  IntColumn get sourceIndex => integer()();

  /// When this row was cached.
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}
