import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/device.dart';

/// Provides normalized devices without exposing their data source.
abstract interface class EquipmentRepository {
  /// Loads the remote device catalogue in source order.
  Future<Result<List<Device>, AppFailure>> getDevices();

  /// Loads one remote device by identifier.
  Future<Result<Device, AppFailure>> getDevice(String id);
}
