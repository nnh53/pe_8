import 'package:drift/drift.dart';

/// Singleton metadata describing the last successful catalogue cache.
class CatalogueMetadata extends Table {
  /// The fixed singleton key (always 0).
  IntColumn get id => integer().withDefault(const Constant(0))();

  /// The timestamp of the last successful remote refresh.
  DateTimeColumn get lastSuccessfulRefreshAt => dateTime().nullable()();

  /// The number of cached device records.
  IntColumn get recordCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
