import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/features/loan_request/data/mapping/loan_request_mapper.dart';
import 'package:pe_8/features/loan_request/data/models/loan_request_response_dto.dart';

void main() {
  const mapper = LoanRequestMapper();

  test('maps epoch-millisecond createdAt from the remote response', () {
    final dto = LoanRequestResponseDto.fromJson(<String, dynamic>{
      'id': 'ff8081819f7e10ae019f88b96c171085',
      'name': 'Campus Equipment Loan Request',
      'createdAt': 1784705281047,
      'data': <String, dynamic>{
        'deviceId': '2',
        'studentId': 'hoangn',
        'borrowDate': '2026-07-22',
        'returnDate': '2026-07-30',
        'purpose': 'demo',
        'deposit': 20,
        'status': 'pending',
      },
    });

    final creation = mapper.toRemoteCreation(dto);

    check(creation.id).equals('ff8081819f7e10ae019f88b96c171085');
    check(creation.status).equals('pending');
    check(creation.createdAt.toUtc()).equals(
      DateTime.fromMillisecondsSinceEpoch(1784705281047, isUtc: true),
    );
  });

  test('maps ISO-8601 createdAt from the remote response', () {
    final dto = LoanRequestResponseDto.fromJson(<String, dynamic>{
      'id': 'abc',
      'name': 'Campus Equipment Loan Request',
      'createdAt': '2026-07-22T07:28:01.047Z',
      'data': <String, dynamic>{'status': 'pending'},
    });

    final creation = mapper.toRemoteCreation(dto);

    check(creation.createdAt.toUtc()).equals(
      DateTime.utc(2026, 7, 22, 7, 28, 1, 47),
    );
  });
}
