//test/widgets/dice/panel/dice_group_test.dart

import 'package:material_ui/material_ui.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:da_roller/widgets/dice/panel/dice_group.dart';

import 'package:da_roller/models/dice/dice_roll.dart';
import 'package:da_roller/widgets/dice/rendering/dice_3d.dart';

void main() {
  group('DiceGroup', () {
    testWidgets('starts with all dice unlocked', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      expect(key.currentState!.isRolling, false);
    });

    testWidgets('panel roll starts rolling all three dice', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      final roll = key.currentState!.roll(
        const DiceRoll(type: DiceRollType.panel, diceCount: 3),
      );

      await tester.pump();

      expect(key.currentState!.isRolling, true);
      expect(key.currentState!.results, [null, null, null]);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await roll;
    });

    testWidgets('single roll affects only the selected die', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      final roll = key.currentState!.roll(
        const DiceRoll(
          type: DiceRollType.single,
          diceCount: 1,
          targetDieIndex: 1,
        ),
      );

      await tester.pump();

      expect(key.currentState!.isRolling, true);
      expect(key.currentState!.results, [null, null, null]);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await roll;

      expect(key.currentState!.isRolling, false);
      expect(key.currentState!.results[0], isNull);
      expect(key.currentState!.results[1], isNotNull);
      expect(key.currentState!.results[2], isNull);
    });

    testWidgets('blocks new rolls during animation', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      final firstRoll = key.currentState!.roll(
        const DiceRoll(type: DiceRollType.panel, diceCount: 3),
      );

      await tester.pump();

      expect(key.currentState!.isRolling, true);

      final secondRoll = key.currentState!.roll(
        const DiceRoll(
          type: DiceRollType.single,
          diceCount: 1,
          targetDieIndex: 0,
        ),
      );

      await expectLater(secondRoll, throwsA(isA<StateError>()));

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await firstRoll;

      expect(key.currentState!.isRolling, false);
      expect(key.currentState!.results.every((result) => result != null), true);
    });

    testWidgets('can select another die after a single roll', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiceGroup(
              key: key,
              onSingleRollRequested: (index) {
                key.currentState!.roll(
                  DiceRoll(
                    type: DiceRollType.single,
                    diceCount: 1,
                    targetDieIndex: index,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Roll the first die.
      final firstRoll = key.currentState!.roll(
        const DiceRoll(
          type: DiceRollType.single,
          diceCount: 1,
          targetDieIndex: 0,
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await firstRoll;

      expect(key.currentState!.results[0], isNotNull);
      expect(key.currentState!.results[1], isNull);
      expect(key.currentState!.results[2], isNull);

      // Select the second die.
      await tester.tap(find.byType(Dice3D).at(1));
      await tester.pump();

      expect(key.currentState!.isRolling, true);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // The second die should now contain the result.
      expect(key.currentState!.isRolling, false);
      expect(key.currentState!.results[0], isNull);
      expect(key.currentState!.results[1], isNotNull);
      expect(key.currentState!.results[2], isNull);
    });

    testWidgets('can select an unused die after one-die damage roll', (
      tester,
    ) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiceGroup(
              key: key,
              diceCount: 1,
              onSingleRollRequested: (index) {
                key.currentState!.roll(
                  DiceRoll(
                    type: DiceRollType.single,
                    diceCount: 1,
                    targetDieIndex: index,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Perform a one-die damage roll.
      final damageRoll = key.currentState!.roll(
        const DiceRoll(type: DiceRollType.damage, diceCount: 1),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await damageRoll;

      expect(key.currentState!.results[0], isNotNull);
      expect(key.currentState!.results[1], isNull);
      expect(key.currentState!.results[2], isNull);

      // Select the second physical die, which was not used for damage.
      await tester.tap(find.byType(Dice3D).at(1));
      await tester.pump();

      expect(key.currentState!.isRolling, true);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(key.currentState!.isRolling, false);
      expect(key.currentState!.results[0], isNull);
      expect(key.currentState!.results[1], isNotNull);
      expect(key.currentState!.results[2], isNull);
    });
  });
}
