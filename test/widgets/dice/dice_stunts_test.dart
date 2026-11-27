//test/widgets/dice/dice_stunts_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/widgets/dice/dice_stunts.dart';

void main() {
  group('hasStunts', () {
    test('returns true when first and second dice match', () {
      expect(hasStunts([4, 4, 6]), isTrue);
    });

    test('returns true when first and Dragon Die match', () {
      expect(hasStunts([4, 6, 4]), isTrue);
    });

    test('returns true when second and Dragon Die match', () {
      expect(hasStunts([6, 4, 4]), isTrue);
    });

    test('returns false when all dice are different', () {
      expect(hasStunts([3, 4, 6]), isFalse);
    });

    test('returns false when any die is null', () {
      expect(hasStunts([null, 4, 4]), isFalse);
      expect(hasStunts([4, null, 4]), isFalse);
      expect(hasStunts([4, 4, null]), isFalse);
    });

    test('returns false when fewer than three dice are provided', () {
      expect(hasStunts([]), isFalse);
      expect(hasStunts([4]), isFalse);
      expect(hasStunts([4, 4]), isFalse);
    });

    test('checks only the first three dice', () {
      expect(hasStunts([3, 4, 6, 3]), isFalse);
      expect(hasStunts([4, 4, 6, 2]), isTrue);
    });
  });
}
