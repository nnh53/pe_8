import '../../../../core/time/clock.dart';
import '../../domain/entities/loan_draft.dart';
import '../../domain/repositories/loan_draft_repository.dart';
import '../daos/loan_draft_dao.dart';

/// Stores the loan draft in the Drift database.
final class LoanDraftRepositoryImpl implements LoanDraftRepository {
  /// Creates the repository around its DAO and clock.
  const LoanDraftRepositoryImpl({required this._dao, required this._clock});

  final LoanDraftDao _dao;
  final Clock _clock;

  @override
  Future<LoanDraft?> loadDraft() => _dao.loadDraft();

  @override
  Future<void> saveDraft(LoanDraft draft) =>
      _dao.saveDraft(draft, updatedAt: _clock.now());

  @override
  Future<void> clearDraft() => _dao.clearDraft();
}
