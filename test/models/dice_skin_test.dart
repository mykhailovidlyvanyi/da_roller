//test/models/dice_skin_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/models/dice_skin.dart';

void main() {
  group('DiceSkin', () {
    test('Classic skin has expected properties', () {
      const skin = DiceSkin.classic;

      expect(skin.id, 'classic');
      expect(skin.name, 'Classic');
      expect(skin.cornerRadius, 12);
      expect(skin.pipStyle, PipStyle.round);
    });

    test('Dragon skin has expected properties', () {
      const skin = DiceSkin.dragon;

      expect(skin.id, 'dragon');
      expect(skin.name, 'Dragon Die');
      expect(skin.oneFaceImage, isNull);
    });

    test('Symbol skin has expected properties', () {
      const skin = DiceSkin.symbol;

      expect(skin.id, 'symbol');
      expect(skin.name, 'Symbol Die');
      expect(skin.oneFaceImage, 'assets/images/symbol.png');
    });
  });
}
