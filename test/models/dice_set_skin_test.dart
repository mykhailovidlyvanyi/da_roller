// test/models/dice_set_skin_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/models/dice_set_skin.dart';

void main() {
  group('DiceSetSkin', () {
    test('Classic set contains three classic dice', () {
      const skinSet = DiceSetSkin.classic;

      expect(skinSet.id, 'classic');
      expect(skinSet.diceSkins.length, 3);

      expect(skinSet.diceSkins.every((skin) => skin.id == 'classic'), true);
    });

    test('Dragon set has two classic dice and one dragon die', () {
      const skinSet = DiceSetSkin.dragon;

      expect(skinSet.id, 'dragon');
      expect(skinSet.diceSkins.length, 3);

      expect(skinSet.diceSkins[0].id, 'classic');
      expect(skinSet.diceSkins[1].id, 'classic');
      expect(skinSet.diceSkins[2].id, 'dragon');
    });

    test('Symbol set has two classic dice and one symbol die', () {
      const skinSet = DiceSetSkin.symbol;

      expect(skinSet.id, 'symbol');
      expect(skinSet.diceSkins.length, 3);

      expect(skinSet.diceSkins[0].id, 'classic');
      expect(skinSet.diceSkins[1].id, 'classic');
      expect(skinSet.diceSkins[2].id, 'symbol');
    });
  });
}
