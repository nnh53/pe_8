// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogue_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogueCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $CachedDevicesTable get cachedDevices => attachedDatabase.cachedDevices;
  $CatalogueMetadataTable get catalogueMetadata =>
      attachedDatabase.catalogueMetadata;
  CatalogueCacheDaoManager get managers => CatalogueCacheDaoManager(this);
}

class CatalogueCacheDaoManager {
  final _$CatalogueCacheDaoMixin _db;
  CatalogueCacheDaoManager(this._db);
  $$CachedDevicesTableTableManager get cachedDevices =>
      $$CachedDevicesTableTableManager(_db.attachedDatabase, _db.cachedDevices);
  $$CatalogueMetadataTableTableManager get catalogueMetadata =>
      $$CatalogueMetadataTableTableManager(
        _db.attachedDatabase,
        _db.catalogueMetadata,
      );
}
