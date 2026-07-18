import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/loan_payload.dart';
import '../../domain/entities/loan_request.dart';
import '../../domain/entities/remote_creation.dart';
import '../models/loan_request_response_dto.dart';

/// Maps loan requests to the exact remote payload and response types.
final class LoanRequestMapper {
  const LoanRequestMapper();

  /// Builds the exact nested object required by the remote endpoint.
  Map<String, Object?> toPayload(LoanRequest request) =>
      buildLoanPayload(request);

  /// Validates a POST response into a confirmed [RemoteCreation].
  RemoteCreation toRemoteCreation(LoanRequestResponseDto dto) {
    final createdAt = DateTime.tryParse(dto.createdAt);
    final status = dto.data['status'];
    if (createdAt == null || status is! String) {
      throw const ResponseDataException(
        'Created request response omitted required fields.',
      );
    }
    return RemoteCreation(
      id: dto.id,
      name: dto.name,
      createdAt: createdAt,
      status: status,
      data: Map<String, Object?>.from(dto.data),
    );
  }

  /// Builds a confirmed domain receipt from a remote creation.
  LoanRequestReceipt toReceipt(RemoteCreation creation, LoanRequest request) =>
      LoanRequestReceipt(
        id: creation.id,
        name: creation.name,
        createdAt: creation.createdAt,
        request: request,
        status: creation.status,
      );
}
