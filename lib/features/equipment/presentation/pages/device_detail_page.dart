import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_providers.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device.dart';

/// Displays safe normalized and raw details for one device.
final class DeviceDetailPage extends ConsumerWidget {
  /// Creates a detail page for [deviceId].
  const DeviceDetailPage({required this.deviceId, super.key});

  /// The remote device identifier.
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(deviceDetailsProvider(deviceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Device details')),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _DetailError(
          message: 'Unable to load this device.',
          onRetry: () => ref.invalidate(deviceDetailsProvider(deviceId)),
        ),
        data: (value) => switch (value) {
          Success(value: final device) => _DeviceDetails(device: device),
          Failure(error: final failure) => _DetailError(
            message: (failure).message,
            onRetry: () => ref.invalidate(deviceDetailsProvider(deviceId)),
          ),
        },
      ),
    );
  }
}

final class _DeviceDetails extends ConsumerWidget {
  const _DeviceDetails({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deposit = ref
        .watch(depositPolicyProvider)
        .depositFor(device.estimatedValue);
    final attributes = device.rawAttributes.entries.toList(growable: false);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.devices,
            size: 82,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          device.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text('${device.category.label} • Device #${device.id}'),
        const SizedBox(height: 20),
        _SummaryCard(device: device, deposit: deposit),
        const SizedBox(height: 20),
        Text('Specifications', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        if (attributes.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No additional specifications were provided.'),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  for (final (index, entry) in attributes.indexed) ...<Widget>[
                    _AttributeRow(name: entry.key, value: entry.value),
                    if (index < attributes.length - 1)
                      const Divider(height: 24),
                  ],
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => context.push('/equipment/${device.id}/request'),
          icon: const Icon(Icons.assignment_outlined),
          label: const Text('Request this device'),
        ),
      ],
    );
  }
}

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.device, required this.deposit});

  final Device device;
  final int deposit;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SummaryValue(
              label: 'Estimated value',
              value: device.estimatedValue == null
                  ? 'Unavailable'
                  : formatMoney(device.estimatedValue!),
            ),
          ),
          const SizedBox(height: 44, child: VerticalDivider()),
          Expanded(
            child: _SummaryValue(
              label: 'Refundable deposit',
              value: formatMoney(deposit),
            ),
          ),
        ],
      ),
    ),
  );
}

final class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 6),
      Text(
        value,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ],
  );
}

final class _AttributeRow extends StatelessWidget {
  const _AttributeRow({required this.name, required this.value});

  final String name;
  final Object? value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(child: Text(name, style: Theme.of(context).textTheme.bodySmall)),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          value?.toString() ?? 'Unavailable',
          textAlign: TextAlign.end,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

final class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    ),
  );
}
