//test/models/character/character_attribute_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/models/character_attribute.dart';

void main() {
  group('CharacterAttribute', () {
    test('should create attribute with default values', () {
      const attribute = CharacterAttribute(name: 'STRENGTH');

      expect(attribute.name, 'STRENGTH');
      expect(attribute.value, 0);
      expect(attribute.focus, '');
    });

    test('should create attribute with custom values', () {
      const attribute = CharacterAttribute(
        name: 'STRENGTH',
        value: 3,
        focus: 'Melee combat',
      );

      expect(attribute.name, 'STRENGTH');
      expect(attribute.value, 3);
      expect(attribute.focus, 'Melee combat');
    });

    test('copyWith should update value', () {
      const attribute = CharacterAttribute(
        name: 'STRENGTH',
        value: 2,
        focus: 'Melee combat',
      );

      final updated = attribute.copyWith(value: 4);

      expect(updated.value, 4);
      expect(updated.name, 'STRENGTH');
      expect(updated.focus, 'Melee combat');
    });

    test('copyWith should update focus', () {
      const attribute = CharacterAttribute(name: 'STRENGTH', value: 2);

      final updated = attribute.copyWith(focus: 'Archery');

      expect(updated.focus, 'Archery');
      expect(updated.name, 'STRENGTH');
      expect(updated.value, 2);
    });

    test('copyWith should not modify original attribute', () {
      const attribute = CharacterAttribute(name: 'STRENGTH', value: 2);

      final updated = attribute.copyWith(value: 5);

      expect(attribute.value, 2);
      expect(updated.value, 5);
    });
  });
}
