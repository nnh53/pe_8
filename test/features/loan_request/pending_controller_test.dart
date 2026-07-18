import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_submission.dart';
import 'package:pe_8/features/loan_request/domain/entities/remote_creation.dart';
import 'package:pe_8/features/loan_request/presentation/providers/pending_controller.dart';

import '../../support/fakes.dart';

Future<void> _settle() => Future<void>.delayed(Duration.zero);

LoanSubmission _pendingSubmission() => LoanSubmission(
  localId: 'local-1',
  idempotencyKey: 'idem-1',
  device: buildDevice(id: '7', name: 'Laptop'),
  payload: const <String, Object?>{
    'name': 'Campus Equipment Loan Request',
    'data': <String, Object?>{
      'deviceId': '7',
      'studentId': 'SE1819',
      'borrowDate': '2026-08-01',
      'returnDate': '2026-08-05',
      'purpose': 'Demo',
      'deposit': 50,
      'status': 'pending',
    },
  },
  state: SubmissionState.pending,
  attemptCount: 1,
  createdAt: DateTime(2026, 8, 1),
);

void main() {
  test(
    'a successful retry marks the submission succeeded with one POST',
    () async {
      final submissions = FakeLoanSubmissionRepository();
      await submissions.save(_pendingSubmission());
      final requests = FakeLoanRequestRepository(
        payloadResult: Success<RemoteCreation, AppFailure>(
          RemoteCreation(
            id: 'remote-42',
            name: 'Campus Equipment Loan Request',
            createdAt: DateTime(2026, 8, 2),
            status: 'pending',
            data: const <String, Object?>{},
          ),
        ),
      );
      final controller = PendingController(
        submissionRepository: submissions,
        requestRepository: requests,
        clock: FakeClock(DateTime(2026, 8, 2)),
      );
      await _settle();

      await controller.retry('local-1');

      check(requests.submitPayloadCalls).equals(1);
      final updated = submissions.saved['local-1']!;
      check(updated.state).equals(SubmissionState.succeeded);
      check(updated.remoteId).equals('remote-42');
    },
  );

  test('an ambiguous retry becomes an unknown outcome', () async {
    final submissions = FakeLoanSubmissionRepository();
    await submissions.save(_pendingSubmission());
    final requests = FakeLoanRequestRepository(
      payloadResult: const Failure<RemoteCreation, AppFailure>(
        AmbiguousFailure(),
      ),
    );
    final controller = PendingController(
      submissionRepository: submissions,
      requestRepository: requests,
      clock: FakeClock(DateTime(2026, 8, 2)),
    );
    await _settle();

    await controller.retry('local-1');

    check(
      submissions.saved['local-1']!.state,
    ).equals(SubmissionState.unknownOutcome);
  });

  test('a transport failure keeps the submission pending', () async {
    final submissions = FakeLoanSubmissionRepository();
    await submissions.save(_pendingSubmission());
    final requests = FakeLoanRequestRepository(
      payloadResult: const Failure<RemoteCreation, AppFailure>(
        TransportFailure(),
      ),
    );
    final controller = PendingController(
      submissionRepository: submissions,
      requestRepository: requests,
      clock: FakeClock(DateTime(2026, 8, 2)),
    );
    await _settle();

    await controller.retry('local-1');

    final updated = submissions.saved['local-1']!;
    check(updated.state).equals(SubmissionState.pending);
    check(updated.attemptCount).equals(2);
  });
}
