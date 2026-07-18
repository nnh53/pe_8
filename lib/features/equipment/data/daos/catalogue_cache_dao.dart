import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/tables/cached_devices.dart';
import '../../../../core/storage/tables/catalogue_metadata.dart';
import '../../domain/entities/cached_catalogue.dart';
import '../../domain/entities/device.dart';
import '../mapping/device_json.dart';

part 'catalogue_cache_dao.g.dart';

/// Reads and atomically replaces the offline catalogue cache.
@DriftAccessor(tables: [CachedDevices, CatalogueMetadata])
class CatalogueCacheDao extends DatabaseAccessor<AppDatabase>
    with _$CatalogueCacheDaoMixin {
  /// Creates the accessor for [db].
  CatalogueCacheDao(super.db);

  /// Loads the cached catalogue, or null when nothing has been cached.
  Future<CachedCatalogue?> loadCachedCatalogue() async {
    final query = select(cachedDevices)
      ..orderBy([(row) => OrderingTerm(expression: row.sourceIndex)]);
    final rows = await query.get();
    if (rows.isEmpty) {
      return null;
    }
    final metadata = await (select(
      catalogueMetadata,
    )..where((row) => row.id.equals(0))).getSingleOrNull();
    return CachedCatalogue(
      devices: rows.map(_toDevice).toList(growable: false),
      lastRefreshedAt: metadata?.lastSuccessfulRefreshAt,
    );
  }

  /// Replaces all cached rows and metadata in a single transaction.
  Future<void> replaceCatalogue(
    List<Device> devices, {
    required DateTime refreshedAt,
  }) {
    return transaction(() async {
      await delete(cachedDevices).go();
      for (final device in devices) {
        await into(cachedDevices).insert(_toRow(device, refreshedAt));
      }
      await into(catalogueMetadata).insertOnConflictUpdate(
        CatalogueMetadataCompanion.insert(
          id: const Value(0),
          lastSuccessfulRefreshAt: Value(refreshedAt),
          recordCount: Value(devices.length),
        ),
      );
    });
  }

  CachedDevicesCompanion _toRow(Device device, DateTime cachedAt) {
    final value = device.estimatedValue;
    return CachedDevicesCompanion.insert(
      deviceId: device.id,
      name: device.name,
      rawDataJson: jsonEncode(Map<String, Object?>.from(device.rawAttributes)),
      estimatedValueMinor: Value(value == null ? null : (value * 100).round()),
      year: Value(device.year),
      category: device.category.name,
      sourceIndex: device.sourceIndex,
      cachedAt: cachedAt,
    );
  }

  Device _toDevice(CachedDevice row) {
    final rawAttributes = switch (jsonDecode(row.rawDataJson)) {
      final Map<String, Object?> map => map,
      _ => const <String, Object?>{},
    };
    return deviceFromJson(<String, Object?>{
      'id': row.deviceId,
      'name': row.name,
      'sourceIndex': row.sourceIndex,
      'category': row.category,
      'estimatedValue': row.estimatedValueMinor == null
          ? null
          : row.estimatedValueMinor! / 100,
      'year': row.year,
      'rawAttributes': rawAttributes,
    });
  }
}
