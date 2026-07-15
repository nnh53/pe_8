import 'dart:collection';

/// A category inferred from a device's name and attributes.
enum DeviceCategory {
  laptop('Laptop'),
  phone('Phone'),
  tablet('Tablet'),
  wearable('Wearable'),
  audio('Audio'),
  other('Other');

  const DeviceCategory(this.label);

  /// The user-facing category label.
  final String label;
}

/// An immutable campus device available for inspection and loan.
final class Device {
  /// Creates a normalized domain device.
  Device({
    required this.id,
    required this.name,
    required this.sourceIndex,
    required this.category,
    required this.estimatedValue,
    required this.year,
    required Map<String, Object?> rawAttributes,
  }) : rawAttributes = UnmodifiableMapView(rawAttributes);

  /// The remote identifier.
  final String id;

  /// The display name.
  final String name;

  /// The original zero-based position from the remote catalogue.
  final int sourceIndex;

  /// The category inferred by the configured classifier.
  final DeviceCategory category;

  /// The normalized estimated value in whole US dollars, when available.
  final double? estimatedValue;

  /// The model or release year, when available.
  final int? year;

  /// All optional remote attributes retained for safe detail rendering.
  final Map<String, Object?> rawAttributes;
}
