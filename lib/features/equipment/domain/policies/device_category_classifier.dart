import '../entities/device.dart';

/// Infers a stable category from remote device information.
abstract interface class DeviceCategoryClassifier {
  /// Returns a category for a device name and its optional attributes.
  DeviceCategory classify(String name, Map<String, Object?> attributes);
}

/// Uses replaceable keyword groups to classify heterogeneous API records.
final class KeywordDeviceCategoryClassifier
    implements DeviceCategoryClassifier {
  /// Creates the default category classifier.
  const KeywordDeviceCategoryClassifier();

  @override
  DeviceCategory classify(String name, Map<String, Object?> attributes) {
    
    final searchable = '$name ${attributes.values.join(' ')}'.toLowerCase();

    if (_containsAny(searchable, const ['macbook', 'laptop', 'notebook'])) {
      return DeviceCategory.laptop;
    }
    if (_containsAny(searchable, const ['iphone', 'phone', 'pixel'])) {
      return DeviceCategory.phone;
    }
    if (_containsAny(searchable, const ['ipad', 'tablet'])) {
      return DeviceCategory.tablet;
    }
    if (_containsAny(searchable, const ['watch', 'wearable', 'fitbit'])) {
      return DeviceCategory.wearable;
    }
    if (_containsAny(searchable, const ['audio', 'headphone', 'speaker'])) {
      return DeviceCategory.audio;
    }
    return DeviceCategory.other;
  }

  bool _containsAny(String value, List<String> keywords) =>
      keywords.any(value.contains);
}
