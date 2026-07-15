import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/equipment/presentation/pages/device_catalogue_page.dart';
import '../features/equipment/presentation/pages/device_detail_page.dart';
import '../features/loan_request/domain/entities/loan_request.dart';
import '../features/loan_request/presentation/pages/loan_request_form_page.dart';
import '../features/loan_request/presentation/pages/request_result_page.dart';

/// Declarative routes for the equipment-loan workflow.
final GoRouter appRouter = GoRouter(
  initialLocation: '/equipment',
  routes: <RouteBase>[
    GoRoute(
      path: '/equipment',
      builder: (context, state) => const DeviceCataloguePage(),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              DeviceDetailPage(deviceId: state.pathParameters['id'] ?? ''),
          routes: <RouteBase>[
            GoRoute(
              path: 'request',
              builder: (context, state) => LoanRequestFormPage(
                deviceId: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/request-result',
      builder: (context, state) {
        final receipt = state.extra;
        if (receipt is LoanRequestReceipt) {
          return RequestResultPage(receipt: receipt);
        }
        return const _MissingResultPage();
      },
    ),
  ],
  errorBuilder: (context, state) =>
      _RouteErrorPage(message: state.error.toString()),
);

final class _MissingResultPage extends StatelessWidget {
  const _MissingResultPage();

  @override
  Widget build(BuildContext context) => const _RouteErrorPage(
    message: 'No confirmed request result is available.',
  );
}

final class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Unable to open page')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/equipment'),
              child: const Text('Back to equipment'),
            ),
          ],
        ),
      ),
    ),
  );
}
