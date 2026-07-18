import '../entities/loan_draft.dart';

/// Persists the single in-progress loan draft.
abstract interface class LoanDraftRepository {
  /// Loads the current draft, or null when none is stored.
  Future<LoanDraft?> loadDraft();

  /// Persists [draft] as the current draft.
  Future<void> saveDraft(LoanDraft draft);

  /// Removes the stored draft.
  Future<void> clearDraft();
}
