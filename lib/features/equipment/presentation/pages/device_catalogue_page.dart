import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_providers.dart';
import '../../domain/entities/device.dart';
import '../../domain/policies/deposit_policy.dart';
import '../providers/catalogue_controller.dart';
import '../widgets/device_card.dart';

/// Displays the remote device catalogue and its primary states.
final class DeviceCataloguePage extends ConsumerWidget {
  /// Creates the catalogue page.
  const DeviceCataloguePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogueControllerProvider);
    final depositPolicy = ref.watch(depositPolicyProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Campus equipment'),
            Text(
              'Choose a device for your next project',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: switch (state) {
        CatalogueLoading() => const _LoadingView(),
        CatalogueError(failure: final failure) => _ErrorView(
          message: failure.message,
          onRetry: ref.read(catalogueControllerProvider.notifier).load,
        ),
        CatalogueContent(
          devices: final devices,
          isRefreshing: final isRefreshing,
        ) =>
          _CatalogueView(
            devices: devices,
            depositPolicy: depositPolicy,
            isRefreshing: isRefreshing,
            onRefresh: ref.read(catalogueControllerProvider.notifier).refresh,
          ),
      },
    );
  }
}

final class _CatalogueView extends StatelessWidget {
  const _CatalogueView({
    required this.devices,
    required this.depositPolicy,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final List<Device> devices;
  final DepositPolicy depositPolicy;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const <Widget>[
            SizedBox(height: 180),
            Icon(Icons.inventory_2_outlined, size: 56),
            SizedBox(height: 16),
            Center(child: Text('No devices are available right now.')),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: devices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final device = devices[index];
              return DeviceCard(
                device: device,
                deposit: depositPolicy.depositFor(device.estimatedValue),
                onTap: () => context.push('/equipment/${device.id}'),
              );
            },
          ),
        ),
        if (isRefreshing)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

final class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading available equipment…'),
      ],
    ),
  );
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.cloud_off_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load equipment',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    ),
  );
}
