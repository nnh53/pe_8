import '../../../equipment/domain/entities/device.dart';

/// A restorable in-progress loan form draft for one device.
final class LoanDraft {
  /// Creates a draft snapshot.
  const LoanDraft({
    required this.device,
    required this.studentId,
    required this.borrowDate,
    required this.returnDate,
    required this.purpose,
    required this.deposit,
  });

  /// The device the draft targets.
  final Device device;

  /// The entered student identifier.
  final String studentId;

  /// The chosen borrow date, when set.
  final DateTime? borrowDate;

  /// The chosen return date, when set.
  final DateTime? returnDate;

  /// The entered purpose.
  final String purpose;

  /// The derived deposit for the device.
  final int deposit;
}
