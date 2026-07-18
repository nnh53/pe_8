import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe_8/features/equipment/domain/entities/device.dart';
import 'package:pe_8/features/equipment/domain/entities/device_sort.dart';
import 'package:pe_8/features/equipment/domain/policies/deposit_policy.dart';

import '../../support/fakes.dart';

void main() {
  const policy = ThresholdDepositPolicy();
  final devices = <Device>[
    buildDevice(id: '0', name: 'banana', sourceIndex: 0, estimatedValue: 2000),
    buildDevice(id: '1', name: 'Apple', sourceIndex: 1, estimatedValue: null),
    buildDevice(id: '2', name: 'apple', sourceIndex: 2, estimatedValue: 500),
  ];

  List<String> idsOf(List<Device> list) =>
      list.map((device) => device.id).toList();

  test('source order reproduces the original order', () {
    final sorted = sortDevices(devices, SortMode.sourceOrder, policy);
    check(idsOf(sorted)).deepEquals(<String>['0', '1', '2']);
  });

  test('name A-Z is case-insensitive with source-order tie-break', () {
    final sorted = sortDevices(devices, SortMode.nameAToZ, policy);
    // 'Apple' (idx1) and 'apple' (idx2) tie; idx1 comes first.
    check(idsOf(sorted)).deepEquals(<String>['1', '2', '0']);
  });

  test('deposit low-high treats a missing price as the standard deposit', () {
    final sorted = sortDevices(devices, SortMode.depositLowHigh, policy);
    // Deposits: id0=50, id1=20 (missing), id2=20. Ties break by source index.
    check(idsOf(sorted)).deepEquals(<String>['1', '2', '0']);
  });

  test('sorting does not mutate the input list', () {
    sortDevices(devices, SortMode.nameAToZ, policy);
    check(idsOf(devices)).deepEquals(<String>['0', '1', '2']);
  });
}
