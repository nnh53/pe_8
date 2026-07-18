import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/loan_request.dart';
import '../entities/remote_creation.dart';

/// Creates loan-request objects on the remote service.
abstract interface class LoanRequestRepository {
  /// Submits a validated [request] and returns a confirmed receipt.
  Future<Result<LoanRequestReceipt, AppFailure>> submit(LoanRequest request);

  /// Submits a stored immutable [payload], used by the pending retry path.
  Future<Result<RemoteCreation, AppFailure>> submitPayload(
    Map<String, Object?> payload,
  );
}
