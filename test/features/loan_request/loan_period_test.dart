import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_period.dart';

import '../../support/fakes.dart';

void main() {
  group('LoanPeriod.create', () {
    final clock = FakeClock(DateTime(2026, 8, 1, 9, 30));

    ({dynamic period, LoanPeriodIssue? issue}) create(
      DateTime borrow,
      DateTime returned,
    ) => LoanPeriod.create(
      borrowDate: borrow,
      returnDate: returned,
      clock: clock,
    );

    test('allows borrowing today', () {
      final result = create(DateTime(2026, 8, 1), DateTime(2026, 8, 5));
      check(result.issue).isNull();
      check(result.period).isNotNull();
    });

    test('rejects a borrow date in the past', () {
      final result = create(DateTime(2026, 7, 31), DateTime(2026, 8, 5));
      check(result.issue).equals(LoanPeriodIssue.borrowDateInPast);
    });

    test('rejects a same-day return', () {
      final result = create(DateTime(2026, 8, 1), DateTime(2026, 8, 1));
      check(result.issue).equals(LoanPeriodIssue.returnNotLater);
    });

    test('rejects a reversed return', () {
      final result = create(DateTime(2026, 8, 5), DateTime(2026, 8, 2));
      check(result.issue).equals(LoanPeriodIssue.returnNotLater);
    });

    test('accepts a 14-day period', () {
      final result = create(DateTime(2026, 8, 1), DateTime(2026, 8, 15));
      check(result.issue).isNull();
      check(result.period).isNotNull();
    });

    test('rejects a 15-day period', () {
      final result = create(DateTime(2026, 8, 1), DateTime(2026, 8, 16));
      check(result.issue).equals(LoanPeriodIssue.exceedsMaximum);
    });

    test('ignores time of day using date-only comparison', () {
      // Borrowing "today" earlier than the current wall-clock time is allowed.
      final result = create(
        DateTime(2026, 8, 1, 0, 1),
        DateTime(2026, 8, 3, 23, 59),
      );
      check(result.issue).isNull();
    });
  });
}
