//test/widgets/character/combat_section_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:da_roller/widgets/character/combat_section.dart';
import 'package:da_roller/widgets/character/combat_stat_card.dart';

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

      // Speed = 10, Charge = 10 ~/ 2, Run = 10 * 2.
      expect(find.text('5'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('updates Charge and Run when Speed changes', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final target = find.byKey(const ValueKey('combat_speed'));

      await tester.tap(target);
      await tester.pumpAndSettle();

      final field = find.descendant(
        of: target,
        matching: find.byType(TextField),
      );

      expect(field, findsOneWidget);

      await tester.enterText(field, '40');

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('40'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('15'), findsNothing);
      expect(find.text('60'), findsNothing);
    });

    testWidgets('keeps Damage taken permanently editable', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays default combat values', (tester) async {
      await tester.pumpWidget(createTestWidget());

      for (final value in [
        '10', // Defence and Speed
        '0', // Shield bonus, Armor, Armor penalty
        '5', // Charge
        '20', // Run
        '30', // Max health and Current health
      ]) {
        expect(find.text(value), findsWidgets);
      }

      final maxManaCard = find.ancestor(
        of: find.text('Max mana'),
        matching: find.byType(CombatStatCard),
      );

      final currentManaCard = find.ancestor(
        of: find.text('Current mana'),
        matching: find.byType(CombatStatCard),
      );

      expect(
        find.descendant(of: maxManaCard, matching: find.text('-')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: currentManaCard, matching: find.text('-')),
        findsOneWidget,
      );
    });

    testWidgets('initializes toggles with default values', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();

      expect(switches, hasLength(2));
      expect(switches[0].value, false);
      expect(switches[1].value, true);
    });

    testWidgets('updates Defence when edited', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final card = find.ancestor(
        of: find.text('Defence'),
        matching: find.byType(CombatStatCard),
      );

      await tester.tap(card);
      await tester.pumpAndSettle();

      final field = find.descendant(of: card, matching: find.byType(TextField));

      expect(field, findsOneWidget);

      await tester.enterText(field, '15');

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: card, matching: find.text('15')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: card, matching: find.text('10')),
        findsNothing,
      );
    });
  });
}
