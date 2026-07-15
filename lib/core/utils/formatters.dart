/// Formats a whole or fractional US-dollar amount for compact UI labels.
String formatMoney(num value) {
  final decimals = value % 1 == 0 ? 0 : 2;
  return '\$${value.toStringAsFixed(decimals)}';
}

/// Formats a local calendar date as an ISO date.
String formatDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

/// Formats a timestamp for the request confirmation UI.
String formatDateTime(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${formatDate(local)} $hour:$minute';
}
