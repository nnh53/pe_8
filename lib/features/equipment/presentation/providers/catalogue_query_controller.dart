import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The raw and debounced query for local catalogue filtering.
final class CatalogueQuery {
  /// Creates a query snapshot.
  const CatalogueQuery({this.raw = '', this.debounced = ''});

  /// The immediate text shown in the search field.
  final String raw;

  /// The value applied to filtering after the debounce elapses.
  final String debounced;

  /// Returns a copy with the supplied values.
  CatalogueQuery copyWith({String? raw, String? debounced}) => CatalogueQuery(
    raw: raw ?? this.raw,
    debounced: debounced ?? this.debounced,
  );
}

/// Owns the search field text and a debounce timer for local filtering.
///
/// Typing never triggers a network request; only the already loaded catalogue
/// is filtered. The debounce timer is cancelled when the controller disposes.
final class CatalogueQueryController extends StateNotifier<CatalogueQuery> {
  /// Creates the controller with a configurable [debounce] duration.
  CatalogueQueryController({this.debounce = const Duration(milliseconds: 400)})
    : super(const CatalogueQuery());

  /// The delay before a query is applied to filtering.
  final Duration debounce;

  Timer? _timer;

  /// Updates the raw query immediately and schedules the debounced update.
  void updateQuery(String value) {
    state = state.copyWith(raw: value);
    _timer?.cancel();
    _timer = Timer(debounce, () {
      state = state.copyWith(debounced: value);
    });
  }

  /// Clears both the raw and debounced query, restoring the full list.
  void clear() {
    _timer?.cancel();
    state = const CatalogueQuery();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
