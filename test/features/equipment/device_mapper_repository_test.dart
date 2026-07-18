import 'dart:convert';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/network/api_client.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/equipment/data/datasources/equipment_remote_datasource.dart';
import 'package:pe_8/features/equipment/data/mapping/device_mapper.dart';
import 'package:pe_8/features/equipment/data/repositories/equipment_repository_impl.dart';
import 'package:pe_8/features/equipment/domain/entities/device.dart';
import 'package:pe_8/features/equipment/domain/policies/device_category_classifier.dart';

import '../../support/fakes.dart';

const _objectsUri = 'https://api.restful-api.dev/objects';

EquipmentRepositoryImpl buildRepository(
  http.Client client,
  FakeCatalogueCacheStore cache,
  FakeClock clock,
) => EquipmentRepositoryImpl(
  remote: EquipmentRemoteDataSource(
    client: ApiClient(client: client),
    objectsUri: Uri.parse(_objectsUri),
  ),
  mapper: const DeviceMapper(KeywordDeviceCategoryClassifier()),
  cache: cache,
  clock: clock,
);

void main() {
  final clock = FakeClock(DateTime(2026, 8, 1));

  test('maps heterogeneous devices and writes the cache on success', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode(<Map<String, Object?>>[
          <String, Object?>{'id': '1', 'name': 'MacBook', 'data': null},
          <String, Object?>{
            'id': '2',
            'name': 'iPhone',
            'data': <String, Object?>{'price': 999, 'year': 2021},
          },
          <String, Object?>{
            'id': '3',
            'name': 'iPad',
            'data': <String, Object?>{'Price': '\$1,099.00'},
          },
        ]),
        200,
      );
    });
    final cache = FakeCatalogueCacheStore();
    final repository = buildRepository(client, cache, clock);

    final result = await repository.getDevices();

    check(result).isA<Success<List<Device>, AppFailure>>();
    final devices = (result as Success<List<Device>, AppFailure>).value;
    check(devices.length).equals(3);

    // data: null maps without crashing and preserves source order.
    check(devices[0].estimatedValue).isNull();
    check(devices[0].sourceIndex).equals(0);

    // Numeric price and year parse.
    check(devices[1].estimatedValue).equals(999);
    check(devices[1].year).equals(2021);

    // String price with symbols and separators parses.
    check(devices[2].estimatedValue).equals(1099);

    // The cache was written exactly once.
    check(cache.replaceCount).equals(1);
    check(cache.stored).isNotNull();
  });

  test(
    'transport failure returns a TransportFailure and skips cache',
    () async {
      final client = MockClient(
        (request) async => throw const SocketException('offline'),
      );
      final cache = FakeCatalogueCacheStore();
      final repository = buildRepository(client, cache, clock);

      final result = await repository.getDevices();

      check(result).isA<Failure<List<Device>, AppFailure>>();
      check(
        (result as Failure<List<Device>, AppFailure>).error,
      ).isA<TransportFailure>();
      check(cache.replaceCount).equals(0);
    },
  );

  test('HTTP rejection is classified as a ServerFailure', () async {
    final client = MockClient((request) async => http.Response('nope', 500));
    final cache = FakeCatalogueCacheStore();
    final repository = buildRepository(client, cache, clock);

    final result = await repository.getDevices();

    check(
      (result as Failure<List<Device>, AppFailure>).error,
    ).isA<ServerFailure>();
  });

  test('malformed success data is classified as a DataFailure', () async {
    final client = MockClient(
      (request) async => http.Response(jsonEncode(<String, Object?>{}), 200),
    );
    final cache = FakeCatalogueCacheStore();
    final repository = buildRepository(client, cache, clock);

    final result = await repository.getDevices();

    check(
      (result as Failure<List<Device>, AppFailure>).error,
    ).isA<DataFailure>();
  });
}
