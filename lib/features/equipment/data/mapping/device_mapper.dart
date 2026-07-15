import '../../domain/entities/device.dart';
import '../../domain/policies/device_category_classifier.dart';
import '../models/device_dto.dart';

/// Maps heterogeneous transport devices into safe domain devices.
final class DeviceMapper {
  /// Creates a mapper with its replaceable classifier.
  const DeviceMapper(this._classifier);

  final DeviceCategoryClassifier _classifier;

  /// Maps [dto] while preserving its remote [sourceIndex].
  Device toDomain(DeviceDto dto, {required int sourceIndex}) {
    final attributes = Map<String, Object?>.from(dto.data ?? const {});
    return Device(
      id: dto.id,
      name: dto.name,
      sourceIndex: sourceIndex,
      category: _classifier.classify(dto.name, attributes),
      estimatedValue: _readEstimatedValue(attributes),
      year: _readYear(attributes),
      rawAttributes: attributes,
    );
  }

  double? _readEstimatedValue(Map<String, Object?> attributes) {
    for (final entry in attributes.entries) {
      final key = entry.key.toLowerCase();
      if (key == 'price' || key.contains('price') || key.contains('value')) {
        final parsed = _asDouble(entry.value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }

  int? _readYear(Map<String, Object?> attributes) {
    for (final entry in attributes.entries) {
      if (entry.key.toLowerCase().contains('year')) {
        return switch (entry.value) {
          int value => value,
          num value => value.toInt(),
          String value => int.tryParse(value.trim()),
          _ => null,
        };
      }
    }
    return null;
  }

  double? _asDouble(Object? value) => switch (value) {
    num number => number.toDouble(),
    String text => double.tryParse(
      text.replaceAll(RegExp(r'[^0-9.\-]'), '').trim(),
    ),
    _ => null,
  };
}
