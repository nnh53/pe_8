import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/compare_add_result.dart';
import '../../domain/repositories/compare_repository.dart';

/// Owns the ordered comparison selection and enforces the two-device limit.
final class CompareController extends StateNotifier<List<String>> {
  /// Creates the controller and restores any persisted selection.
  CompareController(this._repository) : super(const <String>[]) {
    _restore();
  }

  /// The domain limit on how many devices may be compared at once.
  static const int maxSelection = 2;

  final CompareRepository _repository;

  /// Whether [deviceId] is part of the current selection.
  bool isSelected(String deviceId) => state.contains(deviceId);

  /// Adds [deviceId] if room remains, returning the typed outcome.
  Future<CompareAddResult> add(String deviceId) async {
    if (state.contains(deviceId)) {
      return CompareAddResult.alreadySelected;
    }
    if (state.length >= maxSelection) {
      return CompareAddResult.limitReached;
    }
    state = <String>[...state, deviceId];
    await _repository.saveSelection(state);
    return CompareAddResult.added;
  }

  /// Removes [deviceId] from the selection.
  Future<void> remove(String deviceId) async {
    if (!state.contains(deviceId)) {
      return;
    }
    state = <String>[
      for (final id in state)
        if (id != deviceId) id,
    ];
    await _repository.saveSelection(state);
  }

  /// Toggles [deviceId], returning the add outcome or removing it.
  Future<CompareAddResult?> toggle(String deviceId) async {
    if (state.contains(deviceId)) {
      await remove(deviceId);
      return null;
    }
    return add(deviceId);
  }

  /// Drops selected IDs missing from an authoritative [validIds] set.
  ///
  /// Called only after a successful remote catalogue refresh so that offline,
  /// cache-only loads never discard still-valid selections.
  Future<void> reconcileWith(Set<String> validIds) async {
    final retained = <String>[
      for (final id in state)
        if (validIds.contains(id)) id,
    ];
    if (retained.length != state.length) {
      state = retained;
      await _repository.saveSelection(state);
    }
  }

  Future<void> _restore() async {
    final stored = await _repository.loadSelection();
    state = stored.take(maxSelection).toList(growable: false);
  }
}
