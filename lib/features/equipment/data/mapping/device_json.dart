import '../../domain/entities/device.dart';

/// Serializes a [Device] snapshot to and from a JSON-safe map.
///
/// Snapshots let drafts and submissions restore the exact device that was
/// selected, independently of whether it still exists in the live catalogue.
Map<String, Object?> deviceToJson(Device device) => <String, Object?>{
  'id': device.id,
  'name': device.name,
  'sourceIndex': device.sourceIndex,
  'category': device.category.name,
  'estimatedValue': device.estimatedValue,
  'year': device.year,
  'rawAttributes': Map<String, Object?>.from(device.rawAttributes),
};

/// Reconstructs a [Device] from a snapshot produced by [deviceToJson].
Device deviceFromJson(Map<String, Object?> json) => Device(
  id: json['id'] as String,
  name: json['name'] as String,
  sourceIndex: (json['sourceIndex'] as num?)?.toInt() ?? 0,
  category: _categoryFromName(json['category'] as String?),
  estimatedValue: (json['estimatedValue'] as num?)?.toDouble(),
  year: (json['year'] as num?)?.toInt(),
  rawAttributes: switch (json['rawAttributes']) {
    final Map<String, Object?> map => Map<String, Object?>.from(map),
    _ => const <String, Object?>{},
  },
);

DeviceCategory _categoryFromName(String? name) {
  for (final value in DeviceCategory.values) {
    if (value.name == name) {
      return value;
    }
  }
  return DeviceCategory.other;
}
