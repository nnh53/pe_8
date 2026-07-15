import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/result.dart';
import '../entities/loan_request.dart';

/// Creates loan requests without exposing transport details.
abstract interface class LoanRequestRepository {
  /// Submits one finalized request and returns the confirmed remote receipt.
  Future<Result<LoanRequestReceipt, AppFailure>> submit(LoanRequest request);
}
