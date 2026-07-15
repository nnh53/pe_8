import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/device.dart';

/// A compact catalogue card for one normalized device.
final class DeviceCard extends StatelessWidget {
  /// Creates a tappable device card.
  const DeviceCard({
    required this.device,
    required this.deposit,
    required this.onTap,
    super.key,
  });

  /// The device to render.
  final Device device;

  /// The derived refundable deposit.
  final int deposit;

  /// Opens device details.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _CategoryIcon(category: device.category),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    device.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${device.category.label}  •  '
                    '${device.year?.toString() ?? 'Year unavailable'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _FactChip(
                        label: device.estimatedValue == null
                            ? 'Value unavailable'
                            : formatMoney(device.estimatedValue!),
                      ),
                      _FactChip(label: '${formatMoney(deposit)} deposit'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    ),
  );
}

final class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final DeviceCategory category;

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      DeviceCategory.laptop => Icons.laptop_mac,
      DeviceCategory.phone => Icons.smartphone,
      DeviceCategory.tablet => Icons.tablet_mac,
      DeviceCategory.wearable => Icons.watch,
      DeviceCategory.audio => Icons.headphones,
      DeviceCategory.other => Icons.devices_other,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

final class _FactChip extends StatelessWidget {
  const _FactChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    ),
  );
}
