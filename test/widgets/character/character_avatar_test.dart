//test/widgets/character/character_avatar_test.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/widgets/character/character_avatar.dart';

void main() {
  group('CharacterAvatar', () {
    testWidgets('displays placeholder when no photo is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CharacterAvatar())),
      );

      expect(find.text('ADD PHOTO'), findsOneWidget);
      expect(find.byIcon(Icons.add_a_photo_outlined), findsOneWidget);
    });

    testWidgets('uses circular shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CharacterAvatar())),
      );

      final circularContainer = find.byWidgetPredicate((widget) {
        if (widget is! Container) return false;

        final decoration = widget.decoration;

        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.circle;
      });

      expect(circularContainer, findsOneWidget);
    });
  });
}
