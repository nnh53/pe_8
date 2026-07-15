import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device.dart';
import '../../domain/usecases/get_devices.dart';

/// The immutable UI state of the device catalogue.
sealed class CatalogueState {
  const CatalogueState();
}

/// The catalogue has not completed its first load.
final class CatalogueLoading extends CatalogueState {
  const CatalogueLoading();
}

/// The catalogue has visible devices and may be refreshing.
final class CatalogueContent extends CatalogueState {
  const CatalogueContent({required this.devices, this.isRefreshing = false});

  /// Devices in remote source order.
  final List<Device> devices;

  /// Whether a user-requested refresh is active.
  final bool isRefreshing;
}

/// The catalogue failed before any content became available.
final class CatalogueError extends CatalogueState {
  const CatalogueError(this.failure);

  /// The classified failure to present.
  final AppFailure failure;
}

/// Loads and refreshes catalogue state through a use case.
final class CatalogueController extends StateNotifier<CatalogueState> {
  /// Creates the controller before its initial load.
  CatalogueController(this._getDevices) : super(const CatalogueLoading());

  final GetDevices _getDevices;
  bool _requestInFlight = false;

  /// Performs the initial load or retries an empty/error state.
  Future<void> load() => _load(showExistingContent: false);

  /// Refreshes without blanking currently visible content.
  Future<void> refresh() => _load(showExistingContent: true);

  Future<void> _load({required bool showExistingContent}) async {
    if (_requestInFlight) {
      return;
    }
    _requestInFlight = true;
    final current = state;
    if (showExistingContent && current is CatalogueContent) {
      state = CatalogueContent(devices: current.devices, isRefreshing: true);
    } else {
      state = const CatalogueLoading();
    }

    final result = await _getDevices();
    state = switch (result) {
      Success(value: final devices) => CatalogueContent(devices: devices),
      Failure(error: final failure) => CatalogueError(failure),
    };
    _requestInFlight = false;
  }
}
