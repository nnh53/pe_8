import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/loan_request.dart';
import '../../domain/entities/remote_creation.dart';
import '../../domain/repositories/loan_request_repository.dart';
import '../datasources/loan_request_remote_datasource.dart';
import '../mapping/loan_request_mapper.dart';

/// Creates loan requests through the configured remote data source.
final class LoanRequestRepositoryImpl implements LoanRequestRepository {
  /// Creates the repository with its data source and mapper.
  const LoanRequestRepositoryImpl({
    required this._remote,
    required this._mapper,
  });

  final LoanRequestRemoteDataSource _remote;
  final LoanRequestMapper _mapper;

  @override
  Future<Result<LoanRequestReceipt, AppFailure>> submit(
    LoanRequest request,
  ) async {
    final result = await submitPayload(_mapper.toPayload(request));
    return switch (result) {
      Success(value: final creation) => Success(
        _mapper.toReceipt(creation, request),
      ),
      Failure(error: final failure) => Failure(failure),
    };
  }

  @override
  Future<Result<RemoteCreation, AppFailure>> submitPayload(
    Map<String, Object?> payload,
  ) async {
    try {
      final dto = await _remote.submit(payload);
      return Success(_mapper.toRemoteCreation(dto));
    } on TimeoutException {
      // The POST was sent; the server may or may not have created the object.
      return const Failure(AmbiguousFailure());
    } on SocketException {
      // No connection was established, so the request was not delivered.
      return const Failure(TransportFailure());
    } on http.ClientException {
      return const Failure(TransportFailure());
    } on Object catch (error) {
      return Failure(mapFailure(error));
    }
  }
}
