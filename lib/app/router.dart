import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/compare/presentation/pages/compare_page.dart';
import '../features/equipment/presentation/pages/device_catalogue_page.dart';
import '../features/equipment/presentation/pages/device_detail_page.dart';
import '../features/loan_request/domain/entities/loan_request.dart';
import '../features/loan_request/presentation/pages/loan_request_form_page.dart';
import '../features/loan_request/presentation/pages/pending_requests_page.dart';
import '../features/loan_request/presentation/pages/request_result_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Declarative routes for the equipment-loan workflow.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/equipment',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _HomeShell(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/equipment',
              builder: (context, state) => const DeviceCataloguePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/compare',
              builder: (context, state) => const ComparePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/equipment/:id',
      builder: (context, state) =>
          DeviceDetailPage(deviceId: state.pathParameters['id'] ?? ''),
      routes: <RouteBase>[
        GoRoute(
          path: 'request',
          builder: (context, state) =>
              LoanRequestFormPage(deviceId: state.pathParameters['id'] ?? ''),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/pending',
      builder: (context, state) => const PendingRequestsPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
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

/// The bottom-navigation shell hosting the top-level destinations.
final class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.devices_outlined),
          selectedIcon: Icon(Icons.devices),
          label: 'Equipment',
        ),
        NavigationDestination(
          icon: Icon(Icons.compare_arrows_outlined),
          selectedIcon: Icon(Icons.compare_arrows),
          label: 'Compare',
        ),
      ],
    ),
  );
}

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
