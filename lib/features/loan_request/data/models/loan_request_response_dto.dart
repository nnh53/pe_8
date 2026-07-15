import 'package:json_annotation/json_annotation.dart';

part 'loan_request_response_dto.g.dart';

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

  /// The returned ISO-8601 creation time.
  final String createdAt;

  /// Decodes a created request response.
  factory LoanRequestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestResponseDtoFromJson(json);
}
