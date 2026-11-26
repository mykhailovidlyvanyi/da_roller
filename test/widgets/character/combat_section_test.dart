//test/widgets/character/combat_section_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:da_roller/widgets/character/combat_section.dart';

void main() {
  Widget createTestWidget() {
    return const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: CombatSection())),
    );
  }

  group('CombatSection', () {
    testWidgets('displays all six columns', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('DEFENSE'), findsOneWidget);
      expect(find.text('ARMOR'), findsOneWidget);
      expect(find.text('MOVEMENT'), findsOneWidget);
      expect(find.text('HEALTH'), findsOneWidget);
      expect(find.text('MANA'), findsOneWidget);
      expect(find.text('DAMAGE'), findsOneWidget);
    });

    testWidgets('displays all combat statistics', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Defence'), findsOneWidget);
      expect(find.text('Shield bonus'), findsOneWidget);
      expect(find.text('Shield active'), findsOneWidget);

      expect(find.text('Armor'), findsOneWidget);
      expect(find.text('Armor penalty'), findsOneWidget);

      expect(find.text('Speed'), findsOneWidget);
      expect(find.text('Charge'), findsOneWidget);
      expect(find.text('Run'), findsOneWidget);

      expect(find.text('Max health'), findsOneWidget);
      expect(find.text('Current health'), findsOneWidget);

      expect(find.text('Max mana'), findsOneWidget);
      expect(find.text('Current mana'), findsOneWidget);

      expect(find.text('Damage taken'), findsOneWidget);
      expect(find.text('Include armor'), findsOneWidget);
    });

    testWidgets('displays calculated movement values', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Speed = 30, Charge = 30 ~/ 2, Run = 30 * 2.
      expect(find.text('15'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);
    });

    testWidgets('updates Charge and Run when Speed changes', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final target = find.byKey(const ValueKey('combat_speed'));
      await tester.tap(target);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(target);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.descendant(
          of: find.byKey(const ValueKey('combat_speed')),
          matching: find.byType(TextField),
        ),
        '40',
      );
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('40'), findsOneWidget);
      expect(find.text('20'), findsNWidgets(2));
      expect(find.text('80'), findsOneWidget);
      expect(find.text('15'), findsNothing);
      expect(find.text('60'), findsNothing);
    });

    testWidgets('keeps Damage taken permanently editable', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
