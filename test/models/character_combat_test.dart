//test/models/character_combat_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/models/character_combat.dart';

void main() {
  group('CharacterCombat', () {
    test('has correct default values', () {
      final combat = CharacterCombat();

      expect(combat.defence, 10);
      expect(combat.shieldBonus, 0);
      expect(combat.shieldActive, false);

      expect(combat.armor, 0);
      expect(combat.armorPenalty, 0);

      expect(combat.speed, 10);

      expect(combat.maxHealth, 30);
      expect(combat.currentHealth, 30);

      expect(combat.maxMana, isNull);
      expect(combat.currentMana, isNull);

      expect(combat.damageTaken, isNull);
      expect(combat.includeArmor, true);
    });

    test('calculates charge as half of speed', () {
      final combat = CharacterCombat();

      expect(combat.charge, 5);

      combat.speed = 40;

      expect(combat.charge, 20);
    });

    test('calculates run as double speed', () {
      final combat = CharacterCombat();

      expect(combat.run, 20);

      combat.speed = 40;

      expect(combat.run, 80);
    });

    test('allows setting mana and damage values', () {
      final combat = CharacterCombat();

      combat.maxMana = 20;
      combat.currentMana = 14;
      combat.damageTaken = 6;

      expect(combat.maxMana, 20);
      expect(combat.currentMana, 14);
      expect(combat.damageTaken, 6);
    });
  });
}
