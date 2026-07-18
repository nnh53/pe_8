import '../../domain/entities/loan_submission.dart';
import '../../domain/repositories/loan_submission_repository.dart';
import '../daos/loan_submission_dao.dart';

/// Stores loan submissions in the Drift database.
final class LoanSubmissionRepositoryImpl implements LoanSubmissionRepository {
  /// Creates the repository around its DAO.
  const LoanSubmissionRepositoryImpl(this._dao);

  final LoanSubmissionDao _dao;

  @override
  Future<List<LoanSubmission>> loadAll() => _dao.loadAll();

  @override
  Future<int> countUnresolved() => _dao.countUnresolved();

  @override
  Future<LoanSubmission?> findByLocalId(String localId) =>
      _dao.findByLocalId(localId);

  @override
  Future<void> save(LoanSubmission submission) => _dao.upsert(submission);
}
