// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_request_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanRequestResponseDto _$LoanRequestResponseDtoFromJson(
  Map<String, dynamic> json,
) => LoanRequestResponseDto(
  id: json['id'] as String,
  name: json['name'] as String,
  data: json['data'] as Map<String, dynamic>,
  createdAt: parseRemoteCreatedAt(json['createdAt']),
);
