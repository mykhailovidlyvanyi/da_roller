//test/services/dice_service_test.dart

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/services/dice_service.dart';

class FakeRandom implements Random {
  final int value;

  FakeRandom(this.value);

  @override
  int nextInt(int max) => value;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.5;
}

void main() {
  group('DiceService', () {
    test('returns values from 1 to 6', () {
      final service = DiceService();

      for (var i = 0; i < 1000; i++) {
        final result = service.roll();

        expect(result, inInclusiveRange(1, 6));
      }
    });

    test('returns predictable result using injected Random', () {
      for (var i = 0; i < 6; i++) {
        final service = DiceService(random: FakeRandom(i));

        expect(service.roll(), i + 1);
      }
    });
  });
}
