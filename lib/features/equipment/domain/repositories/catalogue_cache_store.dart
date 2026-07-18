import '../entities/cached_catalogue.dart';
import '../entities/device.dart';

/// Persists the offline catalogue snapshot behind a small interface.
///
/// Keeping this abstraction lets the repository be tested with an in-memory
/// fake instead of a real database.
abstract interface class CatalogueCacheStore {
  /// Loads the cached catalogue, or null when nothing has been cached.
  Future<CachedCatalogue?> loadCachedCatalogue();

  /// Replaces all cached devices and metadata atomically.
  Future<void> replaceCatalogue(
    List<Device> devices, {
    required DateTime refreshedAt,
  });
}
