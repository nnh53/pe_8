import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/loan_request_response_dto.dart';

/// Creates loan-request objects through the public RESTful API.
final class LoanRequestRemoteDataSource {
  /// Creates the data source around an injected API client.
  const LoanRequestRemoteDataSource({
    required ApiClient client,
    required Uri objectsUri,
  }) : _client = client,
       _objectsUri = objectsUri;

  final ApiClient _client;
  final Uri _objectsUri;

  /// Posts one exact request payload and returns its decoded response.
  Future<LoanRequestResponseDto> submit(Map<String, Object?> payload) async {
    final json = await _client.postJson(_objectsUri, payload);
    if (json is! Map<String, Object?>) {
      throw const ResponseDataException('Expected a created request object.');
    }
    return LoanRequestResponseDto.fromJson(Map<String, dynamic>.from(json));
  }
}
