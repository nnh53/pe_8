import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../datasources/equipment_remote_datasource.dart';
import '../mapping/device_mapper.dart';

/// Loads and normalizes devices from the configured remote data source.
final class EquipmentRepositoryImpl implements EquipmentRepository {
  /// Creates the repository with its data source and mapper.
  const EquipmentRepositoryImpl({required this._remote, required this._mapper});

  final EquipmentRemoteDataSource _remote;
  final DeviceMapper _mapper;

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
      return Success(List.unmodifiable(devices));
    } on Object catch (error) {
      return Failure(mapFailure(error));
    }
  }
}
