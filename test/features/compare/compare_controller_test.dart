import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/features/compare/domain/entities/compare_add_result.dart';
import 'package:pe_8/features/compare/presentation/providers/compare_controller.dart';

import '../../support/fakes.dart';

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('CompareController', () {
    test('enforces the two-device maximum', () async {
      final controller = CompareController(FakeCompareRepository());
      await _settle();

      check(await controller.add('1')).equals(CompareAddResult.added);
      check(await controller.add('2')).equals(CompareAddResult.added);
      check(await controller.add('3')).equals(CompareAddResult.limitReached);
      check(controller.state.length).equals(2);
    });

    test('reports an already selected device', () async {
      final controller = CompareController(FakeCompareRepository());
      await _settle();

      await controller.add('1');
      check(await controller.add('1')).equals(CompareAddResult.alreadySelected);
    });

    test('restores a persisted ordered selection, capped at two', () async {
      final controller = CompareController(
        FakeCompareRepository(<String>['a', 'b', 'c']),
      );
      await _settle();

      check(controller.state).deepEquals(<String>['a', 'b']);
    });

    test(
      'reconcile drops IDs missing from the authoritative catalogue',
      () async {
        final repository = FakeCompareRepository();
        final controller = CompareController(repository);
        await _settle();

        await controller.add('1');
        await controller.add('2');
        await controller.reconcileWith(<String>{'1'});

        check(controller.state).deepEquals(<String>['1']);
        check(await repository.loadSelection()).deepEquals(<String>['1']);
      },
    );
  });
}
