import 'device.dart';

/// A cached catalogue snapshot with the time of its last successful refresh.
final class CachedCatalogue {
  /// Creates a cached snapshot.
  const CachedCatalogue({required this.devices, required this.lastRefreshedAt});

  /// Cached devices in source order.
  final List<Device> devices;

  /// When the cache was last refreshed from the remote service.
  final DateTime? lastRefreshedAt;
}
