import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/loan_submission.dart';
import '../providers/pending_controller.dart';

/// Lists persisted submissions and offers an explicit, guarded retry.
final class PendingRequestsPage extends ConsumerWidget {
  /// Creates the pending requests page.
  const PendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending requests'),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/equipment');
            }
          },
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Unable to load pending requests.')),
        data: (submissions) => submissions.isEmpty
            ? const _EmptyPending()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                itemCount: submissions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => _SubmissionCard(
                  submission: submissions[index],
                  onRetry: () => ref
                      .read(pendingControllerProvider.notifier)
                      .retry(submissions[index].localId),
                ),
              ),
      ),
    );
  }
}

final class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({required this.submission, required this.onRetry});

  final LoanSubmission submission;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isSending = submission.state == SubmissionState.sending;
    final isSucceeded = submission.state == SubmissionState.succeeded;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    submission.device.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StateChip(state: submission.state),
              ],
            ),
            const SizedBox(height: 10),
            _Fact(label: 'Student', value: submission.studentId),
            _Fact(
              label: 'Dates',
              value: '${submission.borrowDate} → ${submission.returnDate}',
            ),
            _Fact(label: 'Deposit', value: formatMoney(submission.deposit)),
            _Fact(label: 'Purpose', value: submission.purpose),
            _Fact(
              label: 'Created',
              value: formatDateTime(submission.createdAt),
            ),
            _Fact(label: 'Attempts', value: '${submission.attemptCount}'),
            if (submission.remoteId case final remoteId?)
              _Fact(label: 'Remote ID', value: remoteId),
            if (submission.lastError case final error?) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (submission.state == SubmissionState.unknownOutcome) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                'This request may already have been created. Check the service '
                'before retrying to avoid a duplicate.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (!isSucceeded) ...<Widget>[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: isSending ? null : onRetry,
                icon: isSending
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(
                  submission.state == SubmissionState.unknownOutcome
                      ? 'Retry anyway'
                      : 'Retry now',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _StateChip extends StatelessWidget {
  const _StateChip({required this.state});

  final SubmissionState state;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      SubmissionState.pending => ('Pending', Colors.orange),
      SubmissionState.sending => ('Sending', Colors.blue),
      SubmissionState.unknownOutcome => ('Unknown', Colors.deepPurple),
      SubmissionState.succeeded => ('Succeeded', Colors.green),
    };
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }
}

final class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 88,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

final class _EmptyPending extends StatelessWidget {
  const _EmptyPending();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.inbox_outlined, size: 56),
          const SizedBox(height: 16),
          Text(
            'No pending requests',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Requests you save while offline will appear here to retry.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
