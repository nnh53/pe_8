import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/app/app_providers.dart';
import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/equipment/domain/entities/device.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_request.dart';
import 'package:pe_8/features/loan_request/presentation/pages/loan_request_form_page.dart';

import '../../support/fakes.dart';

void main() {
  testWidgets('rapid submit taps result in exactly one POST', (tester) async {
    final device = buildDevice(
      id: '7',
      name: 'Demo Laptop',
      estimatedValue: 1200,
    );
    final fakeRequests = FakeLoanRequestRepository(
      receiptResult: const Failure<LoanRequestReceipt, AppFailure>(
        ServerFailure(statusCode: 500, message: 'boom'),
      ),
    )..delay = const Duration(milliseconds: 300);

    final container = ProviderContainer(
      overrides: <Override>[
        deviceDetailsProvider(
          device.id,
        ).overrideWith((ref) => Success<Device, AppFailure>(device)),
        loanRequestRepositoryProvider.overrideWithValue(fakeRequests),
        loanDraftRepositoryProvider.overrideWithValue(
          FakeLoanDraftRepository(),
        ),
        loanSubmissionRepositoryProvider.overrideWithValue(
          FakeLoanSubmissionRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: LoanRequestFormPage(deviceId: device.id)),
      ),
    );
    await tester.pumpAndSettle();

    // Populate valid form fields via the controller (dates avoid the picker).
    final controller = container.read(
      loanFormControllerProvider(device).notifier,
    );
    final today = DateTime.now();
    controller
      ..updateStudentId('SE1819')
      ..updatePurpose('Mobile app demo')
      ..updateBorrowDate(today)
      ..updateReturnDate(today.add(const Duration(days: 3)));
    await tester.pump();

    // Two rapid taps before the widget can rebuild into its disabled state.
    final button = find.byKey(const ValueKey('submit-loan-button'));
    await tester.tap(button);
    await tester.tap(button);
    await tester.pump();

    // The single-flight guard is active and the button shows progress.
    check(
      container.read(loanFormControllerProvider(device)).isSubmitting,
    ).isTrue();

    await tester.pump(const Duration(milliseconds: 400));

    check(fakeRequests.submitCalls).equals(1);

    // Flush the pending draft-debounce timer before the tree is disposed.
    await tester.pump(const Duration(seconds: 1));
  });
}
