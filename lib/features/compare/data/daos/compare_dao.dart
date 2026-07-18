import 'package:drift/drift.dart';

import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/tables/compare_selections.dart';

part 'compare_dao.g.dart';

/// Reads and writes the persisted, ordered comparison selection.
@DriftAccessor(tables: [CompareSelections])
class CompareDao extends DatabaseAccessor<AppDatabase> with _$CompareDaoMixin {
  /// Creates the accessor for [db].
  CompareDao(super.db);

  /// Returns selected device identifiers ordered by their stored position.
  Future<List<String>> selectedDeviceIds() async {
    final query = select(compareSelections)
      ..orderBy([(row) => OrderingTerm(expression: row.position)]);
    final rows = await query.get();
    return rows.map((row) => row.deviceId).toList(growable: false);
  }

  /// Replaces the persisted selection with [deviceIds] in the given order.
  Future<void> replaceSelection(
    List<String> deviceIds, {
    required DateTime selectedAt,
  }) {
    return transaction(() async {
      await delete(compareSelections).go();
      for (final (index, deviceId) in deviceIds.indexed) {
        await into(compareSelections).insert(
          CompareSelectionsCompanion.insert(
            deviceId: deviceId,
            position: index,
            selectedAt: selectedAt,
          ),
        );
      }
    });
  }
}
