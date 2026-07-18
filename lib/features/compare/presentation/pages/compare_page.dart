import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_providers.dart';
import '../../../../core/utils/formatters.dart';
import '../../../equipment/domain/entities/device.dart';
import '../../../equipment/presentation/providers/catalogue_controller.dart';

/// Shows the up to two selected devices side by side for comparison.
final class ComparePage extends ConsumerWidget {
  /// Creates the compare page.
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(compareControllerProvider);
    final catalogue = ref.watch(catalogueControllerProvider);
    final depositPolicy = ref.watch(depositPolicyProvider);

    final byId = <String, Device>{
      if (catalogue is CatalogueContent)
        for (final device in catalogue.devices) device.id: device,
    };
    final selected = <Device>[for (final id in selectedIds) ?byId[id]];

    return Scaffold(
      appBar: AppBar(title: const Text('Compare devices')),
      body: selected.isEmpty
          ? const _EmptyCompare()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final (index, device) in selected.indexed) ...<Widget>[
                    if (index > 0) const SizedBox(width: 12),
                    Expanded(
                      child: _CompareColumn(
                        device: device,
                        deposit: depositPolicy.depositFor(
                          device.estimatedValue,
                        ),
                        onRemove: () => ref
                            .read(compareControllerProvider.notifier)
                            .remove(device.id),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

final class _CompareColumn extends StatelessWidget {
  const _CompareColumn({
    required this.device,
    required this.deposit,
    required this.onRemove,
  });

  final Device device;
  final int deposit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _CompareRow(label: 'Category', value: device.category.label),
          _CompareRow(
            label: 'Year',
            value: device.year?.toString() ?? 'Unavailable',
          ),
          _CompareRow(
            label: 'Estimated value',
            value: device.estimatedValue == null
                ? 'Unavailable'
                : formatMoney(device.estimatedValue!),
          ),
          _CompareRow(label: 'Deposit', value: formatMoney(deposit)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Remove'),
          ),
        ],
      ),
    ),
  );
}

final class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

final class _EmptyCompare extends StatelessWidget {
  const _EmptyCompare();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.compare_arrows, size: 56),
          const SizedBox(height: 16),
          Text(
            'No devices to compare yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add up to two devices from the catalogue to compare them here.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.go('/equipment'),
            icon: const Icon(Icons.devices),
            label: const Text('Browse equipment'),
          ),
        ],
      ),
    ),
  );
}
