import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/features/equipment/domain/policies/deposit_policy.dart';

void main() {
  group('ThresholdDepositPolicy', () {
    const policy = ThresholdDepositPolicy();

    test('below threshold returns the standard deposit', () {
      check(policy.depositFor(999.99)).equals(20);
    });

    test('exactly at threshold returns the high-value deposit', () {
      check(policy.depositFor(1000)).equals(50);
    });

    test('above threshold returns the high-value deposit', () {
      check(policy.depositFor(1849)).equals(50);
    });

    test('missing value returns the standard deposit', () {
      check(policy.depositFor(null)).equals(20);
    });

    test('non-finite value returns the standard deposit', () {
      check(policy.depositFor(double.nan)).equals(20);
    });

    test('an alternate injected configuration changes the outcome', () {
      const alternate = ThresholdDepositPolicy(
        threshold: 500,
        standardDeposit: 10,
        highValueDeposit: 75,
      );
      check(alternate.depositFor(499)).equals(10);
      check(alternate.depositFor(500)).equals(75);
    });
  });
}
