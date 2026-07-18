import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cached_catalogue.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../daos/catalogue_cache_dao.dart';
import '../datasources/equipment_remote_datasource.dart';
import '../mapping/device_mapper.dart';

/// Loads and normalizes devices from remote and cached data sources.
final class EquipmentRepositoryImpl implements EquipmentRepository {
  /// Creates the repository with its data source, mapper, cache, and clock.
  const EquipmentRepositoryImpl({
    required this._remote,
    required this._mapper,
    required this._cache,
    required this._clock,
  });

  final EquipmentRemoteDataSource _remote;
  final DeviceMapper _mapper;
  final CatalogueCacheDao _cache;
  final Clock _clock;

  @override
  Future<Result<Device, AppFailure>> getDevice(String id) async {
    try {
      final dto = await _remote.getDevice(id);
      return Success(_mapper.toDomain(dto, sourceIndex: 0));
    } on Object catch (error) {
      return Failure(mapFailure(error));
    }
  }

  @override
  Future<Result<List<Device>, AppFailure>> getDevices() async {
    try {
      final dtos = await _remote.getDevices();
      final devices = <Device>[
        for (final (index, dto) in dtos.indexed)
          _mapper.toDomain(dto, sourceIndex: index),
      ];
      final immutable = List<Device>.unmodifiable(devices);
      await _cache.replaceCatalogue(immutable, refreshedAt: _clock.now());
      return Success(immutable);
    } on Object catch (error) {
      return Failure(mapFailure(error));
    }
  }

  @override
  Future<CachedCatalogue?> loadCachedCatalogue() =>
      _cache.loadCachedCatalogue();
}
