//test/models/character/character_combat_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/models/character/character_combat.dart';

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

    group('health limits', () {
      test('limits current health to max health during initialization', () {
        final combat = CharacterCombat(maxHealth: 30, currentHealth: 50);

        expect(combat.currentHealth, 30);
      });

      test('does not allow current health below zero', () {
        final combat = CharacterCombat();

        combat.currentHealth = -10;

        expect(combat.currentHealth, 0);
      });

      test('does not allow current health above max health', () {
        final combat = CharacterCombat();

        combat.currentHealth = 50;

        expect(combat.currentHealth, 30);
      });

      test('does not allow negative damage to increase health above max', () {
        final combat = CharacterCombat();

        combat.currentHealth -= -10;

        expect(combat.currentHealth, 30);
      });

      test('reduces current health when max health decreases', () {
        final combat = CharacterCombat();

        combat.maxHealth = 20;

        expect(combat.currentHealth, 20);
      });

      test(
        'does not allow current health below zero after max health changes',
        () {
          final combat = CharacterCombat();

          combat.currentHealth = -10;
          combat.maxHealth = 20;

          expect(combat.currentHealth, 0);
        },
      );

      test('does not allow negative max health', () {
        final combat = CharacterCombat();

        combat.maxHealth = -10;

        expect(combat.maxHealth, 0);
        expect(combat.currentHealth, 0);
      });
    });
  });
}
