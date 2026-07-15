import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/loan_request.dart';
import '../models/loan_request_response_dto.dart';

/// Maps loan requests to the exact remote payload and response receipt.
final class LoanRequestMapper {
  const LoanRequestMapper();

  /// Builds the exact nested object required by the remote endpoint.
  Map<String, Object?> toPayload(LoanRequest request) => {
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

  /// Builds a confirmed domain receipt from a successful POST response.
  LoanRequestReceipt toReceipt(
    LoanRequestResponseDto dto,
    LoanRequest request,
  ) {
    final createdAt = DateTime.tryParse(dto.createdAt);
    final status = dto.data['status'];
    if (createdAt == null || status is! String) {
      throw const ResponseDataException(
        'Created request response omitted required fields.',
      );
    }
    return LoanRequestReceipt(
      id: dto.id,
      name: dto.name,
      createdAt: createdAt,
      request: request,
      status: status,
    );
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
