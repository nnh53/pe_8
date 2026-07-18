import '../entities/loan_submission.dart';

/// Persists loan submissions and their remote outcomes.
abstract interface class LoanSubmissionRepository {
  /// Loads all submissions, newest first.
  Future<List<LoanSubmission>> loadAll();

  /// Counts submissions that are not yet succeeded.
  Future<int> countUnresolved();

  /// Loads one submission by its local identifier.
  Future<LoanSubmission?> findByLocalId(String localId);

  /// Inserts or replaces [submission].
  Future<void> save(LoanSubmission submission);
}
