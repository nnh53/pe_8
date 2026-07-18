import '../../../../core/time/clock.dart';
import '../../domain/repositories/compare_repository.dart';
import '../daos/compare_dao.dart';

/// Stores the comparison selection in the Drift database.
final class CompareRepositoryImpl implements CompareRepository {
  /// Creates the repository around its DAO and clock.
  const CompareRepositoryImpl({required this._dao, required this._clock});

  final CompareDao _dao;
  final Clock _clock;

  @override
  Future<List<String>> loadSelection() => _dao.selectedDeviceIds();

  @override
  Future<void> saveSelection(List<String> deviceIds) =>
      _dao.replaceSelection(deviceIds, selectedAt: _clock.now());
}
