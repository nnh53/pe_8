import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/loan_request.dart';

/// Displays only the confirmed result returned by the POST endpoint.
final class RequestResultPage extends StatelessWidget {
  /// Creates a result page from a confirmed remote [receipt].
  const RequestResultPage({required this.receipt, super.key});

  /// The confirmed POST response and original request.
  final LoanRequestReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final request = receipt.request;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Request result'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFE2F6EF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF78C9AC), width: 2),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.check_rounded,
                size: 52,
                color: Color(0xFF147D64),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Request created',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'The remote service returned request #${receipt.id}.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  _ResultRow(label: 'Device', value: request.device.name),
                  const Divider(height: 24),
                  _ResultRow(label: 'Student ID', value: request.studentId),
                  const Divider(height: 24),
                  _ResultRow(
                    label: 'Borrow date',
                    value: formatDate(request.period.borrowDate),
                  ),
                  const Divider(height: 24),
                  _ResultRow(
                    label: 'Return date',
                    value: formatDate(request.period.returnDate),
                  ),
                  const Divider(height: 24),
                  _ResultRow(
                    label: 'Deposit',
                    value: formatMoney(request.deposit),
                  ),
                  const Divider(height: 24),
                  _ResultRow(label: 'Status', value: receipt.status),
                  const Divider(height: 24),
                  _ResultRow(
                    label: 'Created at',
                    value: formatDateTime(receipt.createdAt),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/equipment'),
            icon: const Icon(Icons.devices),
            label: const Text('Back to equipment'),
          ),
        ],
      ),
    );
  }
}

final class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(child: Text(label)),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}
