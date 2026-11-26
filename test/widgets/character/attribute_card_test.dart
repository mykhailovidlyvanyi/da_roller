//test/widgets/character/attribute_card_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:da_roller/models/character_attribute.dart';
import 'package:da_roller/widgets/character/attribute_card.dart';

void main() {
  Widget createTestWidget({
    required CharacterAttribute attribute,
    ValueChanged<CharacterAttribute>? onChanged,
    ValueChanged<int?>? onRollDice,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 120,
          child: AttributeCard(
            attribute: attribute,
            onChanged: onChanged ?? (_) {},
            onRollDice: onRollDice ?? (_) {},
          ),
        ),
      ),
    );
  }

  group('AttributeCard', () {
    testWidgets('displays attribute name and value', (tester) async {
      const attribute = CharacterAttribute(name: 'STRENGTH', value: 3);

      await tester.pumpWidget(createTestWidget(attribute: attribute));

      expect(find.text('STRENGTH'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('displays default value', (tester) async {
      const attribute = CharacterAttribute(name: 'STRENGTH');

      await tester.pumpWidget(createTestWidget(attribute: attribute));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays focus when provided', (tester) async {
      const attribute = CharacterAttribute(
        name: 'STRENGTH',
        focus: 'Melee combat',
      );

      await tester.pumpWidget(createTestWidget(attribute: attribute));

      expect(find.text('Melee combat'), findsOneWidget);
    });

    testWidgets('displays placeholder when focus is empty', (tester) async {
      const attribute = CharacterAttribute(name: 'STRENGTH');

      await tester.pumpWidget(createTestWidget(attribute: attribute));

      expect(find.text('Add focus...'), findsOneWidget);
    });

    testWidgets('calls onRollDice with attribute value', (tester) async {
      int? rolledValue;

      const attribute = CharacterAttribute(name: 'STRENGTH', value: 4);

      await tester.pumpWidget(
        createTestWidget(
          attribute: attribute,
          onRollDice: (value) => rolledValue = value,
        ),
      );

      await tester.tap(find.text('4'));

      // Чекаємо завершення розпізнавання одиночного натискання.
      await tester.pump(const Duration(milliseconds: 350));

      expect(rolledValue, 4);
    });
  });
}
