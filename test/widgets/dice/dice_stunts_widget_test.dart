//test/widgets/dice/dice_stunts_widget_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/widgets/dice/dice_stunts.dart';

void main() {
  Widget createTestWidget({
    required bool isAttackRoll,
    required bool isRolling,
    required List<int?> results,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: DiceStunts(
          isAttackRoll: isAttackRoll,
          isRolling: isRolling,
          results: results,
        ),
      ),
    );
  }

  group('DiceStunts', () {
    testWidgets('does not show stunts for a regular roll', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isAttackRoll: false,
          isRolling: false,
          results: [4, 4, 6],
        ),
      );

      expect(find.text('Stunts'), findsNothing);
    });

    testWidgets('does not show stunts while rolling', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isAttackRoll: true,
          isRolling: true,
          results: [4, 4, 6],
        ),
      );

      expect(find.text('Stunts'), findsNothing);
    });

    testWidgets('does not show stunts when dice do not match', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isAttackRoll: true,
          isRolling: false,
          results: [3, 4, 6],
        ),
      );

      expect(find.text('Stunts'), findsNothing);
    });

    testWidgets('shows stunts and Dragon Die result', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isAttackRoll: true,
          isRolling: false,
          results: [4, 4, 6],
        ),
      );

      expect(find.text('Stunts'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
    });
  });
}
