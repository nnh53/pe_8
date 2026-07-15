import 'package:json_annotation/json_annotation.dart';

part 'device_dto.g.dart';

/// A transport representation of a heterogeneous RESTful API object.
@JsonSerializable(createToJson: false)
final class DeviceDto {
  /// Creates a transport device.
  const DeviceDto({required this.id, required this.name, this.data});

  /// The remote identifier.
  final String id;

  /// The remote display name.
  final String name;

  /// Optional heterogeneous nested attributes.
  final Map<String, dynamic>? data;

  /// Decodes a device from JSON.
  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);
}
