import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_providers.dart';
import '../../../compare/domain/entities/compare_add_result.dart';
import '../../../compare/presentation/providers/compare_controller.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_sort.dart';
import '../providers/catalogue_controller.dart';
import '../widgets/device_card.dart';

/// Displays the remote device catalogue with search, sort, and compare.
final class DeviceCataloguePage extends ConsumerWidget {
  /// Creates the catalogue page.
  const DeviceCataloguePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogueControllerProvider);
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
        actions: const <Widget>[_SortMenu()],
      ),
      body: switch (state) {
        CatalogueLoading() => const _LoadingView(),
        CatalogueError(failure: final failure) => _ErrorView(
          message: failure.message,
          onRetry: ref.read(catalogueControllerProvider.notifier).load,
        ),
        CatalogueContent(isRefreshing: final isRefreshing) => _CatalogueView(
          isRefreshing: isRefreshing,
          onRefresh: ref.read(catalogueControllerProvider.notifier).refresh,
        ),
      },
    );
  }
}

final class _SortMenu extends ConsumerWidget {
  const _SortMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(sortModeProvider);
    return PopupMenuButton<SortMode>(
      tooltip: 'Sort',
      icon: const Icon(Icons.sort),
      initialValue: mode,
      onSelected: (value) => ref.read(sortModeProvider.notifier).state = value,
      itemBuilder: (context) => <PopupMenuEntry<SortMode>>[
        for (final value in SortMode.values)
          PopupMenuItem<SortMode>(value: value, child: Text(value.label)),
      ],
    );
  }
}

final class _CatalogueView extends ConsumerWidget {
  const _CatalogueView({required this.isRefreshing, required this.onRefresh});

  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(visibleDevicesProvider);
    final depositPolicy = ref.watch(depositPolicyProvider);
    final selectedIds = ref.watch(compareControllerProvider);
    final query = ref.watch(catalogueQueryControllerProvider).raw;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            key: const ValueKey('catalogue-search-field'),
            decoration: InputDecoration(
              hintText: 'Search devices by name',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: ref
                          .read(catalogueQueryControllerProvider.notifier)
                          .clear,
                    ),
            ),
            onChanged: ref
                .read(catalogueQueryControllerProvider.notifier)
                .updateQuery,
          ),
        ),
        if (isRefreshing) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: devices.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const <Widget>[
                      SizedBox(height: 160),
                      Icon(Icons.inventory_2_outlined, size: 56),
                      SizedBox(height: 16),
                      Center(child: Text('No devices match your search.')),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: devices.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return DeviceCard(
                        device: device,
                        deposit: depositPolicy.depositFor(
                          device.estimatedValue,
                        ),
                        isSelectedForCompare: selectedIds.contains(device.id),
                        onTap: () => context.push('/equipment/${device.id}'),
                        onToggleCompare: () =>
                            _toggleCompare(context, ref, device),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleCompare(
    BuildContext context,
    WidgetRef ref,
    Device device,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(compareControllerProvider.notifier)
        .toggle(device.id);
    final message = switch (result) {
      CompareAddResult.added => '${device.name} added to compare.',
      CompareAddResult.alreadySelected => '${device.name} is already selected.',
      CompareAddResult.limitReached =>
        'You can compare at most ${CompareController.maxSelection} devices.',
      null => '${device.name} removed from compare.',
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
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
