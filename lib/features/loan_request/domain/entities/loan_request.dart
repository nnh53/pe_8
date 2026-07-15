import '../../../equipment/domain/entities/device.dart';
import 'loan_period.dart';

/// A finalized immutable request to borrow one device.
final class LoanRequest {
  /// Creates a validated request payload.
  const LoanRequest({
    required this.device,
    required this.studentId,
    required this.period,
    required this.purpose,
    required this.deposit,
  });

  /// The requested device snapshot.
  final Device device;

  /// The campus student identifier.
  final String studentId;

  /// The validated loan period.
  final LoanPeriod period;

  /// The stated reason for borrowing the device.
  final String purpose;

  /// The derived refundable deposit in whole US dollars.
  final int deposit;
}

/// The confirmed response returned after remote request creation.
final class LoanRequestReceipt {
  /// Creates a remote receipt from the POST response.
  const LoanRequestReceipt({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.request,
    required this.status,
  });

  /// The remote request identifier.
  final String id;

  /// The remote object name.
  final String name;

  /// The remote creation timestamp.
  final DateTime createdAt;

  /// The immutable request sent to the service.
  final LoanRequest request;

  /// The status returned in the nested response data.
  final String status;
}
