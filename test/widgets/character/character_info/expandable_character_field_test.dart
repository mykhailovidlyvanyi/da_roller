//test/widgets/character/character_info/character_field_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/widgets/character/character_info/expandable_character_field.dart';

void main() {
  group('ExpandableCharacterField', () {
    testWidgets('is expanded by default', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableCharacterField(
              label: 'APPEARANCE',
              controller: controller,
              hint: 'Describe character appearance',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('can collapse and expand the field', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableCharacterField(
              label: 'APPEARANCE',
              controller: controller,
              hint: 'Describe character appearance',
            ),
          ),
        ),
      );

      // Collapse
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Expand
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('preserves text after collapsing and expanding', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableCharacterField(
              label: 'APPEARANCE',
              controller: controller,
              hint: 'Describe character appearance',
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Tall character with dark hair',
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(controller.text, 'Tall character with dark hair');

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(controller.text, 'Tall character with dark hair');
    });

    testWidgets('respects initiallyExpanded false', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableCharacterField(
              label: 'APPEARANCE',
              controller: controller,
              hint: 'Describe character appearance',
              initiallyExpanded: false,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });
  });
}
