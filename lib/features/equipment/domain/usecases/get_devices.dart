import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/device.dart';
import '../repositories/equipment_repository.dart';

/// Loads the device catalogue in source order.
final class GetDevices {
  /// Creates the use case with its repository dependency.
  const GetDevices(this._repository);

  final EquipmentRepository _repository;

  /// Executes the catalogue lookup.
  Future<Result<List<Device>, AppFailure>> call() => _repository.getDevices();
}
