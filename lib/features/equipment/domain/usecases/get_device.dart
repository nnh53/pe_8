import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/device.dart';
import '../repositories/equipment_repository.dart';

/// Loads one device for the detail or request workflow.
final class GetDevice {
  /// Creates the use case with its repository dependency.
  const GetDevice(this._repository);

  final EquipmentRepository _repository;

  /// Executes the device lookup.
  Future<Result<Device, AppFailure>> call(String id) =>
      _repository.getDevice(id);
}
