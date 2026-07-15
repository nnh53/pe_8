import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/loan_request.dart';
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
    try {
      final dto = await _remote.submit(_mapper.toPayload(request));
      return Success(_mapper.toReceipt(dto, request));
    } on Object catch (error) {
      return Failure(mapFailure(error));
    }
  }
}
