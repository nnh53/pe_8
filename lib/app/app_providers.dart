import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../core/network/api_client.dart';
import '../core/error/app_failure.dart';
import '../core/time/clock.dart';
import '../core/utils/result.dart';
import '../features/equipment/data/datasources/equipment_remote_datasource.dart';
import '../features/equipment/data/mapping/device_mapper.dart';
import '../features/equipment/data/repositories/equipment_repository_impl.dart';
import '../features/equipment/domain/entities/device.dart';
import '../features/equipment/domain/policies/deposit_policy.dart';
import '../features/equipment/domain/policies/device_category_classifier.dart';
import '../features/equipment/domain/repositories/equipment_repository.dart';
import '../features/equipment/domain/usecases/get_device.dart';
import '../features/equipment/domain/usecases/get_devices.dart';
import '../features/equipment/presentation/providers/catalogue_controller.dart';
import '../features/loan_request/data/datasources/loan_request_remote_datasource.dart';
import '../features/loan_request/data/mapping/loan_request_mapper.dart';
import '../features/loan_request/data/repositories/loan_request_repository_impl.dart';
import '../features/loan_request/domain/repositories/loan_request_repository.dart';
import '../features/loan_request/domain/usecases/submit_loan_request.dart';
import '../features/loan_request/presentation/providers/loan_form_controller.dart';

/// Owns the HTTP transport lifecycle.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Provides centralized JSON request behavior.
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    client: ref.watch(httpClientProvider),
    apiKey: const String.fromEnvironment('RESTFUL_API_KEY'),
  ),
);

/// Provides the required public endpoint with an execution-time override.
final apiObjectsUriProvider = Provider<Uri>(
  (ref) => Uri.parse(
    const String.fromEnvironment(
      'RESTFUL_API_OBJECTS_URL',
      defaultValue: 'https://api.restful-api.dev/objects',
    ),
  ),
);

/// Provides the replaceable system clock.
final clockProvider = Provider<Clock>((ref) => const SystemClock());

/// Provides the replaceable device category policy.
final categoryClassifierProvider = Provider<DeviceCategoryClassifier>(
  (ref) => const KeywordDeviceCategoryClassifier(),
);

/// Provides the single configurable deposit rule used throughout the app.
final depositPolicyProvider = Provider<DepositPolicy>(
  (ref) => const ThresholdDepositPolicy(),
);

final _deviceMapperProvider = Provider<DeviceMapper>(
  (ref) => DeviceMapper(ref.watch(categoryClassifierProvider)),
);

final _equipmentRemoteProvider = Provider<EquipmentRemoteDataSource>(
  (ref) => EquipmentRemoteDataSource(
    client: ref.watch(apiClientProvider),
    objectsUri: ref.watch(apiObjectsUriProvider),
  ),
);

/// Provides normalized equipment access.
final equipmentRepositoryProvider = Provider<EquipmentRepository>(
  (ref) => EquipmentRepositoryImpl(
    remote: ref.watch(_equipmentRemoteProvider),
    mapper: ref.watch(_deviceMapperProvider),
  ),
);

final _getDevicesProvider = Provider<GetDevices>(
  (ref) => GetDevices(ref.watch(equipmentRepositoryProvider)),
);

final _getDeviceProvider = Provider<GetDevice>(
  (ref) => GetDevice(ref.watch(equipmentRepositoryProvider)),
);

/// Owns the catalogue's initial load and refresh lifecycle.
final catalogueControllerProvider =
    StateNotifierProvider<CatalogueController, CatalogueState>((ref) {
      final controller = CatalogueController(ref.watch(_getDevicesProvider));
      Future<void>.microtask(controller.load);
      return controller;
    });

/// Loads one detail device without exposing repository logic to widgets.
final deviceDetailsProvider = FutureProvider.autoDispose
    .family<Result<Device, AppFailure>, String>((ref, id) async {
      final result = await ref.watch(_getDeviceProvider)(id);
      return result;
    });

final _loanRequestRemoteProvider = Provider<LoanRequestRemoteDataSource>(
  (ref) => LoanRequestRemoteDataSource(
    client: ref.watch(apiClientProvider),
    objectsUri: ref.watch(apiObjectsUriProvider),
  ),
);

final _loanRequestMapperProvider = Provider<LoanRequestMapper>(
  (ref) => const LoanRequestMapper(),
);

/// Provides remote loan-request creation.
final loanRequestRepositoryProvider = Provider<LoanRequestRepository>(
  (ref) => LoanRequestRepositoryImpl(
    remote: ref.watch(_loanRequestRemoteProvider),
    mapper: ref.watch(_loanRequestMapperProvider),
  ),
);

final _submitLoanRequestProvider = Provider<SubmitLoanRequest>(
  (ref) => SubmitLoanRequest(ref.watch(loanRequestRepositoryProvider)),
);

/// Owns a loan form for a single normalized device.
final loanFormControllerProvider = StateNotifierProvider.autoDispose
    .family<LoanFormController, LoanFormState, Device>((ref, device) {
      return LoanFormController(
        device: device,
        depositPolicy: ref.watch(depositPolicyProvider),
        clock: ref.watch(clockProvider),
        submitLoanRequest: ref.watch(_submitLoanRequestProvider),
      );
    });
