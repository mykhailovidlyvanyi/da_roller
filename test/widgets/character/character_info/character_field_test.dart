//test/widgets/character/character_info/character_field_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:da_roller/widgets/character/character_info/character_field.dart';

void main() {
  group('CharacterField', () {
    testWidgets('displays label and text field vertically', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterField(
              label: 'NAME',
              controller: controller,
              hint: 'Enter character name',
            ),
          ),
        ),
      );

      expect(find.text('NAME'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter character name'), findsOneWidget);
    });

    testWidgets('displays label and text field horizontally', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterField(
              label: 'NAME',
              controller: controller,
              hint: 'Enter character name',
              horizontal: true,
            ),
          ),
        ),
      );

      expect(find.text('NAME'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('does not display an empty label', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterField(
              label: '',
              controller: controller,
              hint: 'Describe character appearance',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Describe character appearance'), findsOneWidget);
    });
  });
}
