import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/compare/data/daos/compare_dao.dart';
import '../../features/equipment/data/daos/catalogue_cache_dao.dart';
import '../../features/loan_request/data/daos/loan_draft_dao.dart';
import '../../features/loan_request/data/daos/loan_submission_dao.dart';
import 'tables/cached_devices.dart';
import 'tables/catalogue_metadata.dart';
import 'tables/compare_selections.dart';
import 'tables/loan_drafts.dart';
import 'tables/loan_submissions.dart';

part 'app_database.g.dart';

/// The application's SQLite database opened through Drift on Android.
///
/// Schema version 1 (PART 2) introduces [CompareSelections]. Schema version 2
/// (PART 3) adds the offline catalogue cache, loan drafts, and the submission
/// queue while preserving existing comparison rows during migration.
@DriftDatabase(
  tables: [
    CompareSelections,
    CachedDevices,
    CatalogueMetadata,
    LoanDrafts,
    LoanSubmissions,
  ],
  daos: [CompareDao, CatalogueCacheDao, LoanDraftDao, LoanSubmissionDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the default on-device database.
  AppDatabase() : super(_openConnection());

  /// Creates a database around an injected [executor] for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Version 2 adds new tables without dropping compare_selections.
      if (from < 2) {
        await m.createTable(cachedDevices);
        await m.createTable(catalogueMetadata);
        await m.createTable(loanDrafts);
        await m.createTable(loanSubmissions);
      }
    },
  );

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'campus_equipment_loan');
}
