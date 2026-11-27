//test/screens/skin_selection_screen_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/dice/dice_set_skin.dart';
import 'package:da_roller/screens/skin_selection_screen.dart';

void main() {
  group('SkinSelectionScreen', () {
    testWidgets('displays all available skin sets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SkinSelectionScreen(selectedSkinSet: DiceSetSkin.classic),
        ),
      );

      expect(find.text('Classic'), findsOneWidget);
      expect(find.text('Dragon Die'), findsOneWidget);
      expect(find.text('Symbol Die'), findsOneWidget);
      expect(find.text('APPLY'), findsOneWidget);
    });

    testWidgets('initially selects the provided skin set', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SkinSelectionScreen(selectedSkinSet: DiceSetSkin.dragon),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('returns selected skin set after applying', (tester) async {
      DiceSetSkin? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: TextButton(
                  onPressed: () async {
                    result = await Navigator.push<DiceSetSkin>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SkinSelectionScreen(
                          selectedSkinSet: DiceSetSkin.classic,
                        ),
                      ),
                    );
                  },
                  child: const Text('OPEN'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('OPEN'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dragon Die'));
      await tester.tap(find.text('APPLY'));
      await tester.pumpAndSettle();

      expect(result?.id, 'dragon');
    });
  });
}
