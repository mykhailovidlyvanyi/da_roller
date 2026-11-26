//test/widgets/character/combat_stat_card_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:da_roller/widgets/character/combat_stat_card.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 250, child: child)),
      ),
    );
  }

  group('CombatStatCard - numeric value', () {
    testWidgets('displays the initial value', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const CombatStatCard(title: 'Defence', value: 12)),
      );

      expect(find.text('Defence'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('opens editing mode on tap', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const CombatStatCard(title: 'Defence', value: 12)),
      );

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('saves the new value', (tester) async {
      int? updatedValue;
      int? currentValue = 12;

      await tester.pumpWidget(
        createTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return CombatStatCard(
                title: 'Defence',
                value: currentValue,
                onValueChanged: (value) {
                  setState(() {
                    currentValue = value;
                    updatedValue = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Defence'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '18');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(updatedValue, 18);
      expect(find.text('18'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('saves null when the input is cleared', (tester) async {
      int? updatedValue;
      int? currentValue = 12;

      await tester.pumpWidget(
        createTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return CombatStatCard(
                title: 'Defence',
                value: currentValue,
                onValueChanged: (value) {
                  setState(() {
                    currentValue = value;
                    updatedValue = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Defence'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(updatedValue, isNull);
      expect(currentValue, isNull);
      expect(find.text('-'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('cancels editing without saving changes', (tester) async {
      int? updatedValue;

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Defence',
            value: 12,
            onValueChanged: (value) => updatedValue = value,
          ),
        ),
      );

      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '18');
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(updatedValue, isNull);
      expect(find.text('12'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('does not open editing when not editable', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CombatStatCard(title: 'Charge', value: 15, isEditable: false),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  group('CombatStatCard - always editing', () {
    testWidgets('always displays a text field without action icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const CombatStatCard(
            title: 'Damage taken',
            value: 6,
            isAlwaysEditing: true,
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('does not save while the user is typing', (tester) async {
      final updatedValues = <int?>[];

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Damage taken',
            value: null,
            isAlwaysEditing: true,
            onValueChanged: updatedValues.add,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '14');
      await tester.pump();

      expect(updatedValues, isEmpty);
    });

    testWidgets('saves the value when focus is lost', (tester) async {
      final updatedValues = <int?>[];

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Damage taken',
            value: null,
            isAlwaysEditing: true,
            onValueChanged: updatedValues.add,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '14');
      await tester.pump();

      expect(updatedValues, isEmpty);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      expect(updatedValues, [14]);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );
    });

    testWidgets('sends null when the input is cleared and focus is lost', (
      tester,
    ) async {
      final updatedValues = <int?>[];

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Damage taken',
            value: 6,
            isAlwaysEditing: true,
            onValueChanged: updatedValues.add,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(updatedValues, isEmpty);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      expect(updatedValues, [isNull]);
    });

    testWidgets('does not save the same value twice after Enter', (
      tester,
    ) async {
      final updatedValues = <int?>[];

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Damage taken',
            value: null,
            isAlwaysEditing: true,
            onValueChanged: updatedValues.add,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '14');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(updatedValues, [14]);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      expect(updatedValues, [14]);
    });
  });

  group('CombatStatCard - toggle', () {
    testWidgets('calls the callback when the switch changes', (tester) async {
      bool? updatedValue;

      await tester.pumpWidget(
        createTestWidget(
          CombatStatCard(
            title: 'Shield active',
            isToggle: true,
            toggleValue: false,
            onToggleChanged: (value) => updatedValue = value,
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(updatedValue, isTrue);
    });
  });
}
