import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../equipment/domain/entities/device.dart';
import '../../../equipment/domain/policies/deposit_policy.dart';
import '../../domain/entities/loan_draft.dart';
import '../../domain/entities/loan_payload.dart';
import '../../domain/entities/loan_period.dart';
import '../../domain/entities/loan_request.dart';
import '../../domain/entities/loan_submission.dart';
import '../../domain/repositories/loan_draft_repository.dart';
import '../../domain/repositories/loan_submission_repository.dart';
import '../../domain/usecases/submit_loan_request.dart';

/// The outcome of attempting to submit a loan form.
sealed class LoanSubmitResult {
  const LoanSubmitResult();
}

/// The remote service confirmed creation.
final class LoanSubmitSucceeded extends LoanSubmitResult {
  const LoanSubmitSucceeded(this.receipt);

  /// The confirmed remote receipt.
  final LoanRequestReceipt receipt;
}

/// The request could not be delivered; it may be saved as pending.
final class LoanSubmitOffline extends LoanSubmitResult {
  const LoanSubmitOffline();
}

/// The request was sent but its outcome is unknown; it was saved for review.
final class LoanSubmitAmbiguous extends LoanSubmitResult {
  const LoanSubmitAmbiguous(this.localId);

  /// The local identifier of the saved submission.
  final String localId;
}

/// The service rejected the request; the form retains a retryable error.
final class LoanSubmitRejected extends LoanSubmitResult {
  const LoanSubmitRejected();
}

/// The form failed validation and was not sent.
final class LoanSubmitInvalid extends LoanSubmitResult {
  const LoanSubmitInvalid();
}

/// Immutable field and submission state for one loan form.
final class LoanFormState {
  /// Creates loan form state.
  const LoanFormState({
    this.studentId = '',
    this.purpose = '',
    this.borrowDate,
    this.returnDate,
    this.studentIdError,
    this.purposeError,
    this.periodError,
    this.submissionFailure,
    this.isSubmitting = false,
  });

  /// Current student identifier input.
  final String studentId;

  /// Current purpose input.
  final String purpose;

  /// Selected local borrow date.
  final DateTime? borrowDate;

  /// Selected local return date.
  final DateTime? returnDate;

  /// Student identifier validation message.
  final String? studentIdError;

  /// Purpose validation message.
  final String? purposeError;

  /// Loan-period validation message.
  final String? periodError;

  /// A classified remote submission failure.
  final AppFailure? submissionFailure;

  /// Whether a guarded POST is active.
  final bool isSubmitting;

  /// Returns a copy with explicitly supplied values.
  LoanFormState copyWith({
    String? studentId,
    String? purpose,
    DateTime? borrowDate,
    DateTime? returnDate,
    bool clearBorrowDate = false,
    bool clearReturnDate = false,
    String? studentIdError,
    String? purposeError,
    String? periodError,
    AppFailure? submissionFailure,
    bool clearErrors = false,
    bool? isSubmitting,
  }) => LoanFormState(
    studentId: studentId ?? this.studentId,
    purpose: purpose ?? this.purpose,
    borrowDate: clearBorrowDate ? null : borrowDate ?? this.borrowDate,
    returnDate: clearReturnDate ? null : returnDate ?? this.returnDate,
    studentIdError: clearErrors ? null : studentIdError ?? this.studentIdError,
    purposeError: clearErrors ? null : purposeError ?? this.purposeError,
    periodError: clearErrors ? null : periodError ?? this.periodError,
    submissionFailure: clearErrors
        ? null
        : submissionFailure ?? this.submissionFailure,
    isSubmitting: isSubmitting ?? this.isSubmitting,
  );
}

class _LastAttempt {
  const _LastAttempt({
    required this.request,
    required this.payload,
    required this.localId,
    required this.idempotencyKey,
  });

  final LoanRequest request;
  final Map<String, Object?> payload;
  final String localId;
  final String idempotencyKey;
}

/// Owns validation, draft persistence, and single-flight submission.
final class LoanFormController extends StateNotifier<LoanFormState> {
  /// Creates a controller with replaceable domain dependencies.
  LoanFormController({
    required this._device,
    required this._depositPolicy,
    required this._clock,
    required this._submitLoanRequest,
    required this._draftRepository,
    required this._submissionRepository,
    required this._generateId,
    this._draftDebounce = const Duration(milliseconds: 600),
  }) : super(const LoanFormState()) {
    _restoreDraft();
  }

  final Device _device;
  final DepositPolicy _depositPolicy;
  final Clock _clock;
  final SubmitLoanRequest _submitLoanRequest;
  final LoanDraftRepository _draftRepository;
  final LoanSubmissionRepository _submissionRepository;
  final String Function() _generateId;
  final Duration _draftDebounce;

  bool _submissionInFlight = false;
  bool _restoring = false;
  Timer? _draftTimer;
  _LastAttempt? _lastAttempt;

  /// The current derived refundable deposit.
  int get deposit => _depositPolicy.depositFor(_device.estimatedValue);

  /// Updates the student identifier.
  void updateStudentId(String value) {
    state = state.copyWith(studentId: value, clearErrors: true);
    _scheduleDraftSave();
  }

  /// Updates the purpose.
  void updatePurpose(String value) {
    state = state.copyWith(purpose: value, clearErrors: true);
    _scheduleDraftSave();
  }

  /// Updates the local borrow date.
  void updateBorrowDate(DateTime value) {
    state = state.copyWith(borrowDate: value, clearErrors: true);
    _scheduleDraftSave();
  }

  /// Updates the local return date.
  void updateReturnDate(DateTime value) {
    state = state.copyWith(returnDate: value, clearErrors: true);
    _scheduleDraftSave();
  }

  /// Validates and submits exactly one request while a POST is active.
  Future<LoanSubmitResult> submit() async {
    if (_submissionInFlight) {
      return const LoanSubmitInvalid();
    }
    final request = _validatedRequest();
    if (request == null) {
      return const LoanSubmitInvalid();
    }

    _submissionInFlight = true;
    state = state.copyWith(isSubmitting: true, clearErrors: true);
    _lastAttempt = _LastAttempt(
      request: request,
      payload: buildLoanPayload(request),
      localId: _generateId(),
      idempotencyKey: _generateId(),
    );

    final result = await _submitLoanRequest(request);
    _submissionInFlight = false;
    state = state.copyWith(isSubmitting: false);

    switch (result) {
      case Success(value: final receipt):
        await _clearDraft();
        return LoanSubmitSucceeded(receipt);
      case Failure(error: final failure) when failure is TransportFailure:
        return const LoanSubmitOffline();
      case Failure(error: final failure) when failure is AmbiguousFailure:
        final localId = await _persistSubmission(
          SubmissionState.unknownOutcome,
          lastError: failure.message,
        );
        await _clearDraft();
        return LoanSubmitAmbiguous(localId);
      case Failure(error: final failure):
        state = state.copyWith(submissionFailure: failure);
        return const LoanSubmitRejected();
    }
  }

  /// Persists the last offline attempt as a pending submission.
  Future<String?> saveAsPending() async {
    if (_lastAttempt == null) {
      return null;
    }
    final localId = await _persistSubmission(SubmissionState.pending);
    await _clearDraft();
    return localId;
  }

  Future<String> _persistSubmission(
    SubmissionState submissionState, {
    String? lastError,
  }) async {
    final attempt = _lastAttempt!;
    final now = _clock.now();
    final submission = LoanSubmission(
      localId: attempt.localId,
      idempotencyKey: attempt.idempotencyKey,
      device: attempt.request.device,
      payload: attempt.payload,
      state: submissionState,
      attemptCount: 1,
      createdAt: now,
      lastAttemptAt: now,
      lastError: lastError,
    );
    await _submissionRepository.save(submission);
    return attempt.localId;
  }

  LoanRequest? _validatedRequest() {
    final studentId = state.studentId.trim();
    final purpose = state.purpose.trim();
    final borrowDate = state.borrowDate;
    final returnDate = state.returnDate;

    String? studentError;
    String? purposeError;
    String? periodError;
    if (studentId.isEmpty) {
      studentError = 'Enter your student ID.';
    }
    if (purpose.isEmpty) {
      purposeError = 'Explain why you need this device.';
    }

    LoanPeriod? period;
    if (borrowDate == null || returnDate == null) {
      periodError = 'Choose both borrow and return dates.';
    } else {
      final validation = LoanPeriod.create(
        borrowDate: borrowDate,
        returnDate: returnDate,
        clock: _clock,
      );
      period = validation.period;
      periodError = _periodMessage(validation.issue);
    }

    if (studentError != null || purposeError != null || period == null) {
      state = LoanFormState(
        studentId: state.studentId,
        purpose: state.purpose,
        borrowDate: state.borrowDate,
        returnDate: state.returnDate,
        studentIdError: studentError,
        purposeError: purposeError,
        periodError: periodError,
      );
      return null;
    }

    return LoanRequest(
      device: _device,
      studentId: studentId,
      period: period,
      purpose: purpose,
      deposit: deposit,
    );
  }

  String? _periodMessage(LoanPeriodIssue? issue) => switch (issue) {
    LoanPeriodIssue.borrowDateInPast => 'Borrow date cannot be in the past.',
    LoanPeriodIssue.returnNotLater =>
      'Return date must be later than the borrow date.',
    LoanPeriodIssue.exceedsMaximum => 'Loan period cannot exceed 14 days.',
    null => null,
  };

  Future<void> _restoreDraft() async {
    final draft = await _draftRepository.loadDraft();
    if (draft == null || draft.device.id != _device.id) {
      return;
    }
    _restoring = true;
    state = LoanFormState(
      studentId: draft.studentId,
      purpose: draft.purpose,
      borrowDate: draft.borrowDate,
      returnDate: draft.returnDate,
    );
    _restoring = false;
  }

  void _scheduleDraftSave() {
    if (_restoring) {
      return;
    }
    _draftTimer?.cancel();
    _draftTimer = Timer(_draftDebounce, _saveDraft);
  }

  Future<void> _saveDraft() async {
    await _draftRepository.saveDraft(
      LoanDraft(
        device: _device,
        studentId: state.studentId,
        borrowDate: state.borrowDate,
        returnDate: state.returnDate,
        purpose: state.purpose,
        deposit: deposit,
      ),
    );
  }

  Future<void> _clearDraft() async {
    _draftTimer?.cancel();
    await _draftRepository.clearDraft();
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    super.dispose();
  }
}
