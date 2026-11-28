//test/widgets/character/weapons/ranged_weapons_section_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/dice/dice_roll.dart';
import 'package:da_roller/models/weapons/ranged_weapon.dart';
import 'package:da_roller/widgets/character/weapons/ranged_weapons_section.dart';

void main() {
  Future<void> setTestScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpSection(
    WidgetTester tester, {
    ValueChanged<DiceRoll>? onRoll,
  }) async {
    final weapons = <RangedWeapon>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return RangedWeaponsSection(
                weapons: weapons,
                onAddWeapon: (weapon) {
                  setState(() {
                    weapons.add(weapon);
                  });
                },
                onUpdateWeapon: (updatedWeapon) {
                  setState(() {
                    final index = weapons.indexWhere(
                      (weapon) => weapon.id == updatedWeapon.id,
                    );

                    if (index != -1) {
                      weapons[index] = updatedWeapon;
                    }
                  });
                },
                onRemoveWeapon: (weaponId) {
                  setState(() {
                    weapons.removeWhere((weapon) => weapon.id == weaponId);
                  });
                },
                onRoll: onRoll ?? (_) {},
                equippedWeaponId: null,
                onEquipWeapon: (_) {},
              );
            },
          ),
        ),
      ),
    );
  }

  Finder field(String label, {int index = 0}) {
    const fieldIndexes = {
      'Name': 0,
      'Attack Bonus': 1,
      'Damage': 2,
      'Short Range': 4,
      'Long Range': 5,
      'Min Strength': 6,
      'Cost': 7,
      'Weapon Details': 8,
    };

    final baseIndex = fieldIndexes[label];

    if (baseIndex == null) {
      throw ArgumentError('Unknown field: $label');
    }

    return find.byType(TextFormField).at(baseIndex + index);
  }

  Future<void> enterField(
    WidgetTester tester,
    String label,
    String value, {
    int index = 0,
  }) async {
    final targetField = field(label, index: index);

    await tester.ensureVisible(targetField);
    await tester.enterText(targetField, value);
  }

  Future<void> fillRequiredWeaponFields(
    WidgetTester tester, {
    String name = 'Test Bow',
    String attackBonus = '2',
    String damageDice = '3',
    String damageModifier = '1',
    String shortRange = '20',
    String longRange = '60',
  }) async {
    await enterField(tester, 'Name', name);
    await enterField(tester, 'Attack Bonus', attackBonus);
    await enterField(tester, 'Damage', damageDice);
    await enterField(tester, 'Damage', damageModifier, index: 1);
    await enterField(tester, 'Short Range', shortRange);
    await enterField(tester, 'Long Range', longRange);
  }

  Future<void> openAddWeaponDialog(WidgetTester tester) async {
    await tester.tap(find.text('Add Weapon'));
    await tester.pumpAndSettle();

    expect(find.text('Add Ranged Weapon'), findsOneWidget);
  }

  Future<void> addTestWeapon(WidgetTester tester) async {
    await openAddWeaponDialog(tester);
    await fillRequiredWeaponFields(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows empty state and Add Weapon button', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    expect(find.text('RANGED WEAPONS'), findsOneWidget);
    expect(find.text('No ranged weapons added'), findsOneWidget);
    expect(find.text('Add Weapon'), findsOneWidget);
  });

  testWidgets('opens the add weapon dialog', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddWeaponDialog(tester);

    expect(field('Name'), findsOneWidget);
    expect(field('Attack Bonus'), findsOneWidget);
    expect(field('Short Range'), findsOneWidget);
    expect(field('Long Range'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('validates required fields before saving', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddWeaponDialog(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Add Ranged Weapon'), findsOneWidget);
    expect(find.text('This field is required'), findsAtLeastNWidgets(1));
    expect(find.text('No ranged weapons added'), findsOneWidget);
  });

  testWidgets('validates minimum values for damage and ranges', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddWeaponDialog(tester);

    await fillRequiredWeaponFields(
      tester,
      damageDice: '0',
      shortRange: '-1',
      longRange: '-5',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Minimum value is 1'), findsOneWidget);
    expect(find.text('Minimum value is 0'), findsNWidgets(2));
    expect(find.text('Add Ranged Weapon'), findsOneWidget);
  });

  testWidgets('adds a ranged weapon and displays its values', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddWeaponDialog(tester);
    await fillRequiredWeaponFields(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Test Bow'), findsOneWidget);
    expect(find.text('+2'), findsOneWidget);
    expect(find.text('3d6 + 1'), findsOneWidget);
    expect(find.text('20/60'), findsOneWidget);
    expect(find.text('N/A'), findsOneWidget);
    expect(find.text('No ranged weapons added'), findsNothing);
  });

  testWidgets('edits an existing ranged weapon', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addTestWeapon(tester);

    await tester.tap(find.text('Test Bow'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Ranged Weapon'), findsOneWidget);

    await enterField(tester, 'Name', 'Updated Bow');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Updated Bow'), findsOneWidget);
    expect(find.text('Test Bow'), findsNothing);
  });

  testWidgets('removes a ranged weapon', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addTestWeapon(tester);

    await tester.tap(find.byTooltip('Remove weapon'));
    await tester.pumpAndSettle();

    expect(find.text('Test Bow'), findsNothing);
    expect(find.text('No ranged weapons added'), findsOneWidget);
  });

  testWidgets('sends an attack roll with the weapon attack bonus', (
    tester,
  ) async {
    await setTestScreenSize(tester);

    DiceRoll? receivedRoll;

    await pumpSection(tester, onRoll: (roll) => receivedRoll = roll);

    await openAddWeaponDialog(tester);

    await fillRequiredWeaponFields(tester, attackBonus: '4');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Roll attack'));
    await tester.pumpAndSettle();

    expect(receivedRoll, isNotNull);
    expect(receivedRoll!.type, DiceRollType.attack);
    expect(receivedRoll!.diceCount, 3);
    expect(receivedRoll!.modifier, 4);
    expect(receivedRoll!.modifierLabel, 'Attack Bonus');
  });

  testWidgets('sends a damage roll with the weapon damage values', (
    tester,
  ) async {
    await setTestScreenSize(tester);

    DiceRoll? receivedRoll;

    await pumpSection(tester, onRoll: (roll) => receivedRoll = roll);

    await openAddWeaponDialog(tester);

    await fillRequiredWeaponFields(
      tester,
      damageDice: '4',
      damageModifier: '-2',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Roll damage'));
    await tester.pumpAndSettle();

    expect(receivedRoll, isNotNull);
    expect(receivedRoll!.type, DiceRollType.damage);
    expect(receivedRoll!.diceCount, 4);
    expect(receivedRoll!.modifier, -2);
    expect(receivedRoll!.modifierLabel, 'Damage Modifier');
  });
}
