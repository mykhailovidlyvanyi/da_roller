//test/character/attributes_section_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:da_roller/widgets/character/attributes_section.dart';
import 'package:da_roller/widgets/character/attribute_card.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(body: AttributesSection(onRollDice: (_) {})),
    );
  }

  Future<void> setLargeScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> doubleTapFinder(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('AttributesSection', () {
    testWidgets('displays all eight attributes', (tester) async {
      await setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());

      final attributeNames = [
        'COMMUNICATION',
        'CONSTITUTION',
        'CUNNING',
        'DEXTERITY',
        'MAGIC',
        'PERCEPTION',
        'STRENGTH',
        'WILLPOWER',
      ];

      for (final name in attributeNames) {
        expect(find.text(name), findsOneWidget);
      }

      expect(find.byType(AttributeCard), findsNWidgets(8));
    });

    testWidgets('all attributes have default value zero', (tester) async {
      await setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());

      expect(find.text('0'), findsNWidgets(8));
    });

    testWidgets('updates only the selected attribute value', (tester) async {
      await setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());

      final strengthCard = find.ancestor(
        of: find.text('STRENGTH'),
        matching: find.byType(AttributeCard),
      );

      final valueFinder = find.descendant(
        of: strengthCard,
        matching: find.text('0'),
      );

      await doubleTapFinder(tester, valueFinder);

      await tester.enterText(
        find.descendant(of: strengthCard, matching: find.byType(TextField)),
        '5',
      );

      await tester.tap(
        find.descendant(of: strengthCard, matching: find.byIcon(Icons.check)),
      );

      await tester.pumpAndSettle();

      expect(
        find.descendant(of: strengthCard, matching: find.text('5')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: strengthCard, matching: find.text('0')),
        findsNothing,
      );

      expect(find.text('0'), findsNWidgets(7));
    });

    testWidgets('updates only the selected attribute focus', (tester) async {
      await setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());

      final strengthCard = find.ancestor(
        of: find.text('STRENGTH'),
        matching: find.byType(AttributeCard),
      );

      final focusFinder = find.descendant(
        of: strengthCard,
        matching: find.text('Add focus...'),
      );

      await doubleTapFinder(tester, focusFinder);

      await tester.enterText(find.byType(TextField).last, 'Melee combat');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: strengthCard, matching: find.text('Melee combat')),
        findsOneWidget,
      );

      expect(find.text('Add focus...'), findsNWidgets(7));
    });
  });
}
