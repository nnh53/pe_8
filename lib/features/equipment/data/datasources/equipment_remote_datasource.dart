import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/device_dto.dart';

/// Reads device objects from the public RESTful API.
final class EquipmentRemoteDataSource {
  /// Creates the data source around an injected API client.
  const EquipmentRemoteDataSource({
    required this._client,
    required this._objectsUri,
  });

  final ApiClient _client;
  final Uri _objectsUri;

  /// Loads all available devices in remote source order.
  Future<List<DeviceDto>> getDevices() async {
    final json = await _client.getJson(_objectsUri);
    if (json is! List<Object?>) {
      throw const ResponseDataException('Expected a device list.');
    }
    return json.map(_decodeDevice).toList(growable: false);
  }

  /// Loads one device by identifier.
  Future<DeviceDto> getDevice(String id) async {
    final json = await _client.getJson(_objectsUri.resolve('objects/$id'));
    return _decodeDevice(json);
  }

  DeviceDto _decodeDevice(Object? value) {
    if (value is! Map<String, Object?>) {
      throw const ResponseDataException('Expected a device object.');
    }
    return DeviceDto.fromJson(Map<String, dynamic>.from(value));
  }
}
