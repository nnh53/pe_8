import 'loan_request.dart';

/// Builds the exact nested object required by the remote endpoint.
///
/// This is the single source of truth for the payload shape so the form path
/// and the persisted retry path always send identical fields.
Map<String, Object?> buildLoanPayload(LoanRequest request) => <String, Object?>{
  'name': 'Campus Equipment Loan Request',
  'data': <String, Object?>{
    'deviceId': request.device.id,
    'studentId': request.studentId,
    'borrowDate': _date(request.period.borrowDate),
    'returnDate': _date(request.period.returnDate),
    'purpose': request.purpose,
    'deposit': request.deposit,
    'status': 'pending',
  },
};

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';
