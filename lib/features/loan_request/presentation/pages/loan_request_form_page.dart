import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_providers.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/result.dart';
import '../../../equipment/domain/entities/device.dart';

/// Loads a device and displays its Riverpod-owned loan form.
final class LoanRequestFormPage extends ConsumerWidget {
  /// Creates the request form route for [deviceId].
  const LoanRequestFormPage({required this.deviceId, super.key});

  /// The requested device identifier.
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(deviceDetailsProvider(deviceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Loan request')),
      body: result.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const _LoadError(message: 'Unable to prepare this request.'),
        data: (value) => switch (value) {
          Success(value: final device) => _LoadedLoanForm(device: device),
          Failure(error: final failure) => _LoadError(
            message: (failure as AppFailure).message,
          ),
        },
      ),
    );
  }
}

final class _LoadedLoanForm extends ConsumerWidget {
  const _LoadedLoanForm({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = loanFormControllerProvider(device);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        _DeviceHeader(device: device, deposit: controller.deposit),
        const SizedBox(height: 22),
        Text('Student details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('student-id-field'),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Student ID',
            hintText: 'e.g. SE1819',
            errorText: state.studentIdError,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          onChanged: controller.updateStudentId,
        ),
        const SizedBox(height: 22),
        Text('Loan period', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _DateButton(
                label: 'Borrow date',
                value: state.borrowDate,
                onPressed: state.isSubmitting
                    ? null
                    : () => _pickDate(
                        context: context,
                        current: state.borrowDate,
                        onSelected: controller.updateBorrowDate,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateButton(
                label: 'Return date',
                value: state.returnDate,
                onPressed: state.isSubmitting
                    ? null
                    : () => _pickDate(
                        context: context,
                        current: state.returnDate,
                        onSelected: controller.updateReturnDate,
                      ),
              ),
            ),
          ],
        ),
        if (state.periodError case final error?) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 22),
        Text('Purpose', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('purpose-field'),
          minLines: 3,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'How will you use this device?',
            errorText: state.purposeError,
            alignLabelWithHint: true,
          ),
          onChanged: controller.updatePurpose,
        ),
        if (state.submissionFailure case final failure?) ...<Widget>[
          const SizedBox(height: 16),
          _SubmissionError(failure: failure),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          key: const ValueKey('submit-loan-button'),
          onPressed: state.isSubmitting
              ? null
              : () async {
                  final receipt = await controller.submit();
                  if (receipt != null && context.mounted) {
                    context.go('/request-result', extra: receipt);
                  }
                },
          child: state.isSubmitting
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Submit loan request'),
        ),
        const SizedBox(height: 10),
        Text(
          'Submitting creates a pending request with the remote service.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime? current,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: current ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );
    if (selected != null) {
      onSelected(selected);
    }
  }
}

final class _DeviceHeader extends StatelessWidget {
  const _DeviceHeader({required this.device, required this.deposit});

  final Device device;
  final int deposit;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.devices),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  device.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text('${formatMoney(deposit)} refundable deposit'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

final class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final DateTime? value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      alignment: Alignment.centerLeft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.calendar_today_outlined, size: 18),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 2),
              Text(value == null ? 'Choose date' : formatDate(value!)),
            ],
          ),
        ),
      ],
    ),
  );
}

final class _SubmissionError extends StatelessWidget {
  const _SubmissionError({required this.failure});

  final AppFailure failure;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(failure.message)),
        ],
      ),
    ),
  );
}

final class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}
