/// Derives a refundable deposit from a nullable estimated device value.
abstract interface class DepositPolicy {
  /// Returns a whole-dollar refundable deposit.
  int depositFor(double? estimatedValue);
}

/// A threshold-based policy whose values can be replaced at composition time.
final class ThresholdDepositPolicy implements DepositPolicy {
  /// Creates a configurable threshold rule.
  const ThresholdDepositPolicy({
    this.threshold = 1000,
    this.standardDeposit = 20,
    this.highValueDeposit = 50,
  });

  /// The minimum device value that receives [highValueDeposit].
  final double threshold;

  /// The deposit for lower, missing, or invalid values.
  final int standardDeposit;

  /// The deposit for values at or above [threshold].
  final int highValueDeposit;

  @override
  int depositFor(double? estimatedValue) {
    if (estimatedValue == null || !estimatedValue.isFinite) {
      return standardDeposit;
    }
    return estimatedValue >= threshold ? highValueDeposit : standardDeposit;
  }
}
