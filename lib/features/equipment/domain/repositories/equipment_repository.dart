import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/cached_catalogue.dart';
import '../entities/device.dart';

/// Provides normalized devices without exposing their data source.
abstract interface class EquipmentRepository {
  /// Loads the remote device catalogue in source order.
  ///
  /// On success the catalogue is also written to the offline cache.
  Future<Result<List<Device>, AppFailure>> getDevices();

  /// Loads one remote device by identifier.
  Future<Result<Device, AppFailure>> getDevice(String id);

  /// Loads the cached catalogue, or null when nothing has been cached.
  Future<CachedCatalogue?> loadCachedCatalogue();
}
