import '../../../../core/time/clock.dart';

/// The reason a proposed loan period is invalid.
enum LoanPeriodIssue { borrowDateInPast, returnNotLater, exceedsMaximum }

/// A validated pair of local calendar dates for a loan request.
final class LoanPeriod {
  const LoanPeriod._({required this.borrowDate, required this.returnDate});

  /// The first calendar day of the loan.
  final DateTime borrowDate;

  /// The strictly later calendar day on which the device is returned.
  final DateTime returnDate;

  /// Validates and creates a loan period of no more than [maximumDays].
  static ({LoanPeriod? period, LoanPeriodIssue? issue}) create({
    required DateTime borrowDate,
    required DateTime returnDate,
    required Clock clock,
    int maximumDays = 14,
  }) {
    final today = _dateOnly(clock.now());
    final borrow = _dateOnly(borrowDate);
    final returned = _dateOnly(returnDate);
    if (borrow.isBefore(today)) {
      return (period: null, issue: LoanPeriodIssue.borrowDateInPast);
    }
    if (!returned.isAfter(borrow)) {
      return (period: null, issue: LoanPeriodIssue.returnNotLater);
    }
    if (returned.difference(borrow).inDays > maximumDays) {
      return (period: null, issue: LoanPeriodIssue.exceedsMaximum);
    }
    return (
      period: LoanPeriod._(borrowDate: borrow, returnDate: returned),
      issue: null,
    );
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
