import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/equipment/domain/policies/deposit_policy.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_period.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_request.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_submission.dart';
import 'package:pe_8/features/loan_request/domain/usecases/submit_loan_request.dart';
import 'package:pe_8/features/loan_request/presentation/providers/loan_form_controller.dart';

import '../../support/fakes.dart';

void main() {
  final device = buildDevice(id: '7', name: 'Laptop', estimatedValue: 1200);
  final clock = FakeClock(DateTime(2026, 8, 1, 10));

  LoanFormController buildController(
    FakeLoanRequestRepository requests, {
    FakeLoanDraftRepository? drafts,
    FakeLoanSubmissionRepository? submissions,
  }) {
    var counter = 0;
    final controller = LoanFormController(
      device: device,
      depositPolicy: const ThresholdDepositPolicy(),
      clock: clock,
      submitLoanRequest: SubmitLoanRequest(requests),
      draftRepository: drafts ?? FakeLoanDraftRepository(),
      submissionRepository: submissions ?? FakeLoanSubmissionRepository(),
      generateId: () => 'id-${++counter}',
    );
    controller
      ..updateStudentId('SE1819')
      ..updatePurpose('Mobile app demo')
      ..updateBorrowDate(DateTime(2026, 8, 1))
      ..updateReturnDate(DateTime(2026, 8, 5));
    return controller;
  }

  test(
    'offline failure yields an offline result and saves a pending record',
    () async {
      final requests = FakeLoanRequestRepository(
        receiptResult: const Failure<LoanRequestReceipt, AppFailure>(
          TransportFailure(),
        ),
      );
      final drafts = FakeLoanDraftRepository();
      final submissions = FakeLoanSubmissionRepository();
      final controller = buildController(
        requests,
        drafts: drafts,
        submissions: submissions,
      );

      final result = await controller.submit();
      check(result).isA<LoanSubmitOffline>();

      final localId = await controller.saveAsPending();
      check(localId).isNotNull();
      final saved = submissions.saved[localId];
      check(saved).isNotNull();
      check(saved!.state).equals(SubmissionState.pending);
      check(saved.attemptCount).equals(1);
      check(drafts.clearCount).isGreaterThan(0);
    },
  );

  test('ambiguous failure saves an unknown-outcome record', () async {
    final requests = FakeLoanRequestRepository(
      receiptResult: const Failure<LoanRequestReceipt, AppFailure>(
        AmbiguousFailure(),
      ),
    );
    final submissions = FakeLoanSubmissionRepository();
    final controller = buildController(requests, submissions: submissions);

    final result = await controller.submit();

    check(result).isA<LoanSubmitAmbiguous>();
    check(
      submissions.saved.values.single.state,
    ).equals(SubmissionState.unknownOutcome);
  });

  test('successful submission clears the draft', () async {
    final receipt = LoanRequestReceipt(
      id: '99',
      name: 'Campus Equipment Loan Request',
      createdAt: DateTime(2026, 8, 1, 10, 5),
      request: LoanRequest(
        device: device,
        studentId: 'SE1819',
        period: LoanPeriod.create(
          borrowDate: DateTime(2026, 8, 1),
          returnDate: DateTime(2026, 8, 5),
          clock: clock,
        ).period!,
        purpose: 'Mobile app demo',
        deposit: 50,
      ),
      status: 'pending',
    );
    final requests = FakeLoanRequestRepository(
      receiptResult: Success<LoanRequestReceipt, AppFailure>(receipt),
    );
    final drafts = FakeLoanDraftRepository();
    final controller = buildController(requests, drafts: drafts);

    final result = await controller.submit();

    check(result).isA<LoanSubmitSucceeded>();
    check(drafts.clearCount).isGreaterThan(0);
  });

  test(
    'single-flight guard sends exactly one POST for concurrent taps',
    () async {
      final requests = FakeLoanRequestRepository(
        receiptResult: const Failure<LoanRequestReceipt, AppFailure>(
          ServerFailure(statusCode: 500, message: 'boom'),
        ),
      )..delay = const Duration(milliseconds: 80);
      final controller = buildController(requests);

      final results = await Future.wait(<Future<LoanSubmitResult>>[
        controller.submit(),
        controller.submit(),
      ]);

      check(requests.submitCalls).equals(1);
      check(results.whereType<LoanSubmitInvalid>().length).equals(1);
    },
  );
}
