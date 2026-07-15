import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/time/clock.dart';
import '../../../../core/utils/result.dart';
import '../../../equipment/domain/entities/device.dart';
import '../../../equipment/domain/policies/deposit_policy.dart';
import '../../domain/entities/loan_period.dart';
import '../../domain/entities/loan_request.dart';
import '../../domain/usecases/submit_loan_request.dart';

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

/// Owns validation and single-flight submission for one device loan form.
final class LoanFormController extends StateNotifier<LoanFormState> {
  /// Creates a controller with replaceable domain dependencies.
  LoanFormController({
    required this._device,
    required this._depositPolicy,
    required this._clock,
    required this._submitLoanRequest,
  }) : super(const LoanFormState());

  final Device _device;
  final DepositPolicy _depositPolicy;
  final Clock _clock;
  final SubmitLoanRequest _submitLoanRequest;
  bool _submissionInFlight = false;

  /// The current derived refundable deposit.
  int get deposit => _depositPolicy.depositFor(_device.estimatedValue);

  /// Updates the student identifier.
  void updateStudentId(String value) {
    state = state.copyWith(studentId: value, clearErrors: true);
  }

  /// Updates the purpose.
  void updatePurpose(String value) {
    state = state.copyWith(purpose: value, clearErrors: true);
  }

  /// Updates the local borrow date.
  void updateBorrowDate(DateTime value) {
    state = state.copyWith(borrowDate: value, clearErrors: true);
  }

  /// Updates the local return date.
  void updateReturnDate(DateTime value) {
    state = state.copyWith(returnDate: value, clearErrors: true);
  }

  /// Validates and submits exactly one request while a POST is active.
  Future<LoanRequestReceipt?> submit() async {
    if (_submissionInFlight) {
      return null;
    }
    final request = _validatedRequest();
    if (request == null) {
      return null;
    }

    _submissionInFlight = true;
    state = state.copyWith(isSubmitting: true, clearErrors: true);
    final result = await _submitLoanRequest(request);
    _submissionInFlight = false;
    return switch (result) {
      Success(value: final receipt) => _complete(receipt),
      Failure(error: final failure) => _fail(failure),
    };
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

  LoanRequestReceipt _complete(LoanRequestReceipt receipt) {
    state = state.copyWith(isSubmitting: false, clearErrors: true);
    return receipt;
  }

  LoanRequestReceipt? _fail(AppFailure failure) {
    state = state.copyWith(
      isSubmitting: false,
      submissionFailure: failure,
      clearErrors: true,
    );
    return null;
  }
}
