import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/compare/data/daos/compare_dao.dart';
import 'tables/compare_selections.dart';

part 'app_database.g.dart';

/// The application's SQLite database opened through Drift on Android.
///
/// Schema version 1 (PART 2) introduces [CompareSelections]. Later PARTs add
/// tables while preserving existing comparison rows during migration.
@DriftDatabase(tables: [CompareSelections], daos: [CompareDao])
class AppDatabase extends _$AppDatabase {
  /// Opens the default on-device database.
  AppDatabase() : super(_openConnection());

  /// Creates a database around an injected [executor] for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Future PARTs add tables here without dropping compare_selections.
    },
  );

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'campus_equipment_loan');
}
