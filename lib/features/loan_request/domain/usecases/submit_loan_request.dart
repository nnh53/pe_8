import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/loan_request.dart';
import '../repositories/loan_request_repository.dart';

/// Submits one finalized loan request.
final class SubmitLoanRequest {
  /// Creates the use case with its repository dependency.
  const SubmitLoanRequest(this._repository);

  final LoanRequestRepository _repository;

  /// Executes remote request creation.
  Future<Result<LoanRequestReceipt, AppFailure>> call(LoanRequest request) =>
      _repository.submit(request);
}
