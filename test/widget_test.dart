// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:da_roller/main.dart';

void main() {
  testWidgets('Character Sheet screen is displayed', (tester) async {
    await tester.pumpWidget(const DiceRollerApp());

    expect(find.text('CHARACTER SHEET'), findsOneWidget);
    expect(find.text('ATTRIBUTES'), findsOneWidget);
    expect(find.text('COMBAT'), findsOneWidget);
    expect(find.text('ABILITIES & TALENTS'), findsOneWidget);
    expect(find.text('EQUIPMENT'), findsOneWidget);
    expect(find.text('NOTES'), findsOneWidget);
  });
}
