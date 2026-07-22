import 'package:json_annotation/json_annotation.dart';

part 'loan_request_response_dto.g.dart';

/// Parses a remote `createdAt` that may be epoch milliseconds or ISO-8601.
DateTime parseRemoteCreatedAt(Object? value) {
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  throw FormatException('Invalid createdAt value: $value');
}

/// A transport representation of a created loan-request object.
@JsonSerializable(createToJson: false)
final class LoanRequestResponseDto {
  /// Creates a POST response transport model.
  const LoanRequestResponseDto({
    required this.id,
    required this.name,
    required this.data,
    required this.createdAt,
  });

  /// The returned remote identifier.
  final String id;

  /// The returned object name.
  final String name;

  /// The returned nested request data.
  final Map<String, dynamic> data;

  /// The returned creation time (epoch ms or ISO-8601 from the API).
  @JsonKey(fromJson: parseRemoteCreatedAt)
  final DateTime createdAt;

  /// Decodes a created request response.
  factory LoanRequestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestResponseDtoFromJson(json);
}
