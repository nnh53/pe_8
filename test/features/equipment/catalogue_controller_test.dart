import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/core/error/app_failure.dart';
import 'package:pe_8/core/utils/result.dart';
import 'package:pe_8/features/equipment/domain/entities/cached_catalogue.dart';
import 'package:pe_8/features/equipment/domain/entities/device.dart';
import 'package:pe_8/features/equipment/presentation/providers/catalogue_controller.dart';

import '../../support/fakes.dart';

void main() {
  group('CatalogueController stale-while-revalidate', () {
    test('shows fresh remote content on success', () async {
      final remote = <Device>[buildDevice(id: '1', name: 'Fresh')];
      final controller = CatalogueController(
        FakeEquipmentRepository(remoteResult: Success(remote)),
      );

      await controller.load();

      final state = controller.state;
      check(state).isA<CatalogueContent>();
      final content = state as CatalogueContent;
      check(content.isOffline).isFalse();
      check(content.devices.single.name).equals('Fresh');
    });

    test(
      'falls back to cache and flags offline on transport failure',
      () async {
        final cached = <Device>[buildDevice(id: '9', name: 'Cached')];
        final controller = CatalogueController(
          FakeEquipmentRepository(
            remoteResult: const Failure(TransportFailure()),
            cached: CachedCatalogue(devices: cached, lastRefreshedAt: null),
          ),
        );

        await controller.load();

        final content = controller.state as CatalogueContent;
        check(content.isOffline).isTrue();
        check(content.devices.single.name).equals('Cached');
      },
    );

    test('shows an error when neither remote nor cache is available', () async {
      final controller = CatalogueController(
        FakeEquipmentRepository(
          remoteResult: const Failure(TransportFailure()),
        ),
      );

      await controller.load();

      check(controller.state).isA<CatalogueError>();
    });

    test('reconciles compare selections after a successful refresh', () async {
      final remote = <Device>[buildDevice(id: '1', name: 'Kept')];
      final reconciled = <Set<String>>[];
      final controller = CatalogueController(
        FakeEquipmentRepository(remoteResult: Success(remote)),
        onRemoteRefreshSuccess: (devices) =>
            reconciled.add(devices.map((d) => d.id).toSet()),
      );

      await controller.load();

      check(reconciled.single).deepEquals(<String>{'1'});
    });
  });
}
