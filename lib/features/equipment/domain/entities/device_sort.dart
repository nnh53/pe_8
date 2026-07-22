import '../policies/deposit_policy.dart';
import 'device.dart';

/// The stable ways a catalogue may be ordered for display.
enum SortMode {
  /// The exact remote source order.
  sourceOrder('Source order'),

  /// Ascending derived deposit, then source order.
  depositLowHigh('Deposit: low to high'),

  /// Case-insensitive name, then source order.
  nameAToZ('Name: A to Z');

  const SortMode(this.label);

  /// The user-facing label for the sort control.
  final String label;
}

/// Returns a new list of [devices] ordered by [mode] without mutating input.
///
/// Ties always fall back to each device's [Device.sourceIndex] so returning to
/// [SortMode.sourceOrder] exactly reproduces the remote order. Missing prices
/// participate through [depositPolicy] rather than a separate sorting rule.
List<Device> sortDevices(
  List<Device> devices,
  SortMode mode,
  DepositPolicy depositPolicy,
) {
  final sorted = List<Device>.of(devices);

  int bySource(Device a, Device b) => a.sourceIndex.compareTo(b.sourceIndex);
  
  switch (mode) {
    case SortMode.sourceOrder:
      sorted.sort(bySource);
    case SortMode.nameAToZ:
      sorted.sort((a, b) {
        final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return byName != 0 ? byName : bySource(a, b);
      });
    case SortMode.depositLowHigh:
      sorted.sort((a, b) {
        final byDeposit = depositPolicy
            .depositFor(a.estimatedValue)
            .compareTo(depositPolicy.depositFor(b.estimatedValue));
        return byDeposit != 0 ? byDeposit : bySource(a, b);
      });
  }
  return List.unmodifiable(sorted);
}
