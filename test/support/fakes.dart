import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/time/clock.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/compare/domain/repositories/compare_repository.dart';
import 'package:pe_8/features/equipment/domain/entities/cached_catalogue.dart';
import 'package:pe_8/features/equipment/domain/entities/device.dart';
import 'package:pe_8/features/equipment/domain/repositories/catalogue_cache_store.dart';
import 'package:pe_8/features/equipment/domain/repositories/equipment_repository.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_draft.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_request.dart';
import 'package:pe_8/features/loan_request/domain/entities/loan_submission.dart';
import 'package:pe_8/features/loan_request/domain/entities/remote_creation.dart';
import 'package:pe_8/features/loan_request/domain/repositories/loan_draft_repository.dart';
import 'package:pe_8/features/loan_request/domain/repositories/loan_request_repository.dart';
import 'package:pe_8/features/loan_request/domain/repositories/loan_submission_repository.dart';

/// A deterministic clock for time-sensitive tests.
final class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  /// Advances the clock by [duration].
  void advance(Duration duration) => _now = _now.add(duration);

  /// Sets the current time.
  set current(DateTime value) => _now = value;

  @override
  DateTime now() => _now;
}

/// Builds a normalized [Device] for tests.
Device buildDevice({
  String id = '1',
  String name = 'Test Device',
  int sourceIndex = 0,
  DeviceCategory category = DeviceCategory.other,
  double? estimatedValue,
  int? year,
  Map<String, Object?> rawAttributes = const <String, Object?>{},
}) => Device(
  id: id,
  name: name,
  sourceIndex: sourceIndex,
  category: category,
  estimatedValue: estimatedValue,
  year: year,
  rawAttributes: rawAttributes,
);

/// An in-memory catalogue cache for repository tests.
final class FakeCatalogueCacheStore implements CatalogueCacheStore {
  CachedCatalogue? stored;
  int replaceCount = 0;

  @override
  Future<CachedCatalogue?> loadCachedCatalogue() async => stored;

  @override
  Future<void> replaceCatalogue(
    List<Device> devices, {
    required DateTime refreshedAt,
  }) async {
    replaceCount++;
    stored = CachedCatalogue(devices: devices, lastRefreshedAt: refreshedAt);
  }
}

/// A scripted equipment repository for controller tests.
final class FakeEquipmentRepository implements EquipmentRepository {
  FakeEquipmentRepository({this.remoteResult, this.cached, this.deviceResult});

  Result<List<Device>, AppFailure>? remoteResult;
  CachedCatalogue? cached;
  Result<Device, AppFailure>? deviceResult;
  int getDevicesCalls = 0;

  @override
  Future<Result<List<Device>, AppFailure>> getDevices() async {
    getDevicesCalls++;
    return remoteResult ?? const Failure(UnexpectedFailure());
  }

  @override
  Future<Result<Device, AppFailure>> getDevice(String id) async =>
      deviceResult ?? const Failure(UnexpectedFailure());

  @override
  Future<CachedCatalogue?> loadCachedCatalogue() async => cached;
}

/// An in-memory compare repository.
final class FakeCompareRepository implements CompareRepository {
  FakeCompareRepository([List<String>? initial])
    : _stored = List<String>.of(initial ?? const <String>[]);

  List<String> _stored;

  @override
  Future<List<String>> loadSelection() async => List<String>.of(_stored);

  @override
  Future<void> saveSelection(List<String> deviceIds) async {
    _stored = List<String>.of(deviceIds);
  }
}

/// An in-memory loan draft repository.
final class FakeLoanDraftRepository implements LoanDraftRepository {
  LoanDraft? draft;
  int clearCount = 0;

  @override
  Future<void> clearDraft() async {
    clearCount++;
    draft = null;
  }

  @override
  Future<LoanDraft?> loadDraft() async => draft;

  @override
  Future<void> saveDraft(LoanDraft draft) async => this.draft = draft;
}

/// An in-memory loan submission repository.
final class FakeLoanSubmissionRepository implements LoanSubmissionRepository {
  final Map<String, LoanSubmission> saved = <String, LoanSubmission>{};

  @override
  Future<int> countUnresolved() async =>
      saved.values.where((s) => s.state != SubmissionState.succeeded).length;

  @override
  Future<LoanSubmission?> findByLocalId(String localId) async => saved[localId];

  @override
  Future<List<LoanSubmission>> loadAll() async =>
      saved.values.toList(growable: false);

  @override
  Future<void> save(LoanSubmission submission) async =>
      saved[submission.localId] = submission;
}

/// A scripted loan request repository that records POST calls.
final class FakeLoanRequestRepository implements LoanRequestRepository {
  FakeLoanRequestRepository({this.receiptResult, this.payloadResult});

  Result<LoanRequestReceipt, AppFailure>? receiptResult;
  Result<RemoteCreation, AppFailure>? payloadResult;
  int submitCalls = 0;
  int submitPayloadCalls = 0;

  /// Optional async delay to simulate a slow network.
  Duration delay = Duration.zero;

  @override
  Future<Result<LoanRequestReceipt, AppFailure>> submit(
    LoanRequest request,
  ) async {
    submitCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return receiptResult ?? const Failure(UnexpectedFailure());
  }

  @override
  Future<Result<RemoteCreation, AppFailure>> submitPayload(
    Map<String, Object?> payload,
  ) async {
    submitPayloadCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return payloadResult ?? const Failure(UnexpectedFailure());
  }
}
