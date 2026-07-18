import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_providers.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/loan_submission.dart';
import '../../domain/repositories/loan_request_repository.dart';
import '../../domain/repositories/loan_submission_repository.dart';

/// Loads persisted submissions and performs explicit, guarded retries.
final class PendingController
    extends StateNotifier<AsyncValue<List<LoanSubmission>>> {
  /// Creates the controller and loads existing submissions.
  PendingController({
    required LoanSubmissionRepository submissionRepository,
    required LoanRequestRepository requestRepository,
    required this._clock,
  }) : _submissions = submissionRepository,
       _requests = requestRepository,
       super(const AsyncValue<List<LoanSubmission>>.loading()) {
    load();
  }

  final LoanSubmissionRepository _submissions;
  final LoanRequestRepository _requests;
  final Clock _clock;
  final Set<String> _inFlight = <String>{};

  /// Reloads all persisted submissions.
  Future<void> load() async {
    state = const AsyncValue<List<LoanSubmission>>.loading();
    try {
      state = AsyncValue<List<LoanSubmission>>.data(
        await _submissions.loadAll(),
      );
    } on Object catch (error, stackTrace) {
      state = AsyncValue<List<LoanSubmission>>.error(error, stackTrace);
    }
  }

  /// Performs exactly one guarded POST for the submission [localId].
  Future<void> retry(String localId) async {
    if (_inFlight.contains(localId)) {
      return;
    }
    final submission = await _submissions.findByLocalId(localId);
    if (submission == null || submission.state == SubmissionState.succeeded) {
      return;
    }
    _inFlight.add(localId);
    final now = _clock.now();
    var updated = submission.copyWith(
      state: SubmissionState.sending,
      attemptCount: submission.attemptCount + 1,
      lastAttemptAt: now,
      clearError: true,
    );
    await _submissions.save(updated);
    await load();

    final result = await _requests.submitPayload(submission.payload);
    updated = switch (result) {
      Success(value: final creation) => updated.copyWith(
        state: SubmissionState.succeeded,
        completedAt: _clock.now(),
        remoteId: creation.id,
        remoteCreatedAt: creation.createdAt,
        clearError: true,
      ),
      Failure(error: final failure) when failure is AmbiguousFailure =>
        updated.copyWith(
          state: SubmissionState.unknownOutcome,
          lastError: failure.message,
        ),
      Failure(error: final AppFailure failure) => updated.copyWith(
        state: SubmissionState.pending,
        lastError: failure.message,
      ),
    };
    await _submissions.save(updated);
    _inFlight.remove(localId);
    await load();
  }
}

/// Owns the pending submissions list and retry lifecycle.
final pendingControllerProvider =
    StateNotifierProvider<PendingController, AsyncValue<List<LoanSubmission>>>(
      (ref) => PendingController(
        submissionRepository: ref.watch(loanSubmissionRepositoryProvider),
        requestRepository: ref.watch(loanRequestRepositoryProvider),
        clock: ref.watch(clockProvider),
      ),
    );

/// The count of submissions that still require attention.
final pendingCountProvider = Provider<int>((ref) {
  final state = ref.watch(pendingControllerProvider);
  return state.maybeWhen(
    data: (submissions) =>
        submissions.where((s) => s.state != SubmissionState.succeeded).length,
    orElse: () => 0,
  );
});
