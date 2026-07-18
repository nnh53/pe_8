import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/equipment_repository.dart';

/// The immutable UI state of the device catalogue.
sealed class CatalogueState {
  const CatalogueState();
}

/// The catalogue has not completed its first load and has no cached content.
final class CatalogueLoading extends CatalogueState {
  const CatalogueLoading();
}

/// The catalogue has visible devices, possibly cached or refreshing.
final class CatalogueContent extends CatalogueState {
  const CatalogueContent({
    required this.devices,
    this.isRefreshing = false,
    this.isOffline = false,
    this.lastRefreshedAt,
  });

  /// Devices in remote source order.
  final List<Device> devices;

  /// Whether a refresh is currently active.
  final bool isRefreshing;

  /// Whether the visible devices come from the offline cache.
  final bool isOffline;

  /// When the cache was last refreshed from the remote service.
  final DateTime? lastRefreshedAt;

  /// Returns a copy with the supplied values.
  CatalogueContent copyWith({
    List<Device>? devices,
    bool? isRefreshing,
    bool? isOffline,
    DateTime? lastRefreshedAt,
  }) => CatalogueContent(
    devices: devices ?? this.devices,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    isOffline: isOffline ?? this.isOffline,
    lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
  );
}

/// The catalogue failed before any content became available.
final class CatalogueError extends CatalogueState {
  const CatalogueError(this.failure);

  /// The classified failure to present.
  final AppFailure failure;
}

/// Loads cached content first, then revalidates from the remote service.
final class CatalogueController extends StateNotifier<CatalogueState> {
  /// Creates the controller before its initial load.
  CatalogueController(this._repository, {this.onRemoteRefreshSuccess})
    : super(const CatalogueLoading());

  final EquipmentRepository _repository;

  /// Invoked with the authoritative devices after a successful remote load.
  final void Function(List<Device> devices)? onRemoteRefreshSuccess;

  bool _requestInFlight = false;

  /// Performs the initial cached-then-remote load.
  Future<void> load() => _load(showExistingContent: false);

  /// Refreshes without blanking currently visible content.
  Future<void> refresh() => _load(showExistingContent: true);

  Future<void> _load({required bool showExistingContent}) async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    try {
      final current = state;
      final currentContent = current is CatalogueContent ? current : null;
      List<Device>? visible = currentContent?.devices;
      DateTime? lastRefreshedAt = currentContent?.lastRefreshedAt;

      if (!showExistingContent || currentContent == null) {
        final cached = await _repository.loadCachedCatalogue();
        if (cached != null && cached.devices.isNotEmpty) {
          visible = cached.devices;
          lastRefreshedAt = cached.lastRefreshedAt;
          state = CatalogueContent(
            devices: cached.devices,
            isRefreshing: true,
            lastRefreshedAt: cached.lastRefreshedAt,
          );
        } else {
          state = const CatalogueLoading();
        }
      } else {
        state = currentContent.copyWith(isRefreshing: true);
      }

      final result = await _repository.getDevices();
      switch (result) {
        case Success(value: final devices):
          state = CatalogueContent(
            devices: devices,
            lastRefreshedAt: DateTime.now(),
          );
          onRemoteRefreshSuccess?.call(devices);
        case Failure(error: final failure):
          if (visible != null) {
            state = CatalogueContent(
              devices: visible,
              isOffline: failure is TransportFailure,
              lastRefreshedAt: lastRefreshedAt,
            );
          } else {
            state = CatalogueError(failure);
          }
      }
    } finally {
      _requestInFlight = false;
    }
  }
}
