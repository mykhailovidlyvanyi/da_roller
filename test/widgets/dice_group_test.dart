//test/widgets/dice_group_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/widgets/dice/dice_group.dart';

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

    testWidgets('rollAll starts rolling all three dice', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      key.currentState!.rollAll();

      await tester.pump();

      expect(key.currentState!.isRolling, true);
      expect(key.currentState!.results, [null, null, null]);
    });

    testWidgets('rollSingle rolls only selected die', (tester) async {
      final key = GlobalKey<DiceGroupState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DiceGroup(key: key)),
        ),
      );

      key.currentState!.rollSingle(1);

      await tester.pump();

      expect(key.currentState!.isRolling, true);
      expect(key.currentState!.results, [null, null, null]);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

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

      key.currentState!.rollAll();

      await tester.pump();

      expect(key.currentState!.isRolling, true);

      key.currentState!.rollSingle(0);

      await tester.pump();

      expect(key.currentState!.isRolling, true);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(key.currentState!.isRolling, false);

      expect(key.currentState!.results.every((result) => result != null), true);
    });
  });
}
