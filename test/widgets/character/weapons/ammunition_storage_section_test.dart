//test/widgets/character/weapons/ammunition_storage_section_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/ammunition/ammunition_storage.dart';
import 'package:da_roller/widgets/character/weapons/ammunition_storage_section.dart';

import 'package:da_roller/models/weapons/weapon_group.dart';

class AmmunitionTestHost extends StatefulWidget {
  const AmmunitionTestHost({super.key});

  @override
  State<AmmunitionTestHost> createState() => _AmmunitionTestHostState();
}

class _AmmunitionTestHostState extends State<AmmunitionTestHost> {
  AmmunitionStorage storage = const AmmunitionStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmmunitionStorageSection(
        equippedStackId: null,
        onEquipStack: (_) {},
        storage: storage,
        onStorageChanged: (updatedStorage) {
          setState(() {
            storage = updatedStorage;
          });
        },
      ),
    );
  }
}

void main() {
  Future<void> setTestScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AmmunitionTestHost()));
  }

  Finder field(String label) {
    const fieldIndexes = {'Name': 0, 'Quantity': 1, 'Ammunition Details': 2};

    final index = fieldIndexes[label];

    if (index == null) {
      throw ArgumentError('Unknown field: $label');
    }

    return find.byType(TextFormField).at(index);
  }

  Future<void> enterField(
    WidgetTester tester,
    String label,
    String value,
  ) async {
    final targetField = field(label);

    await tester.ensureVisible(targetField);
    await tester.enterText(targetField, value);
  }

  Future<void> openAddAmmunitionDialog(WidgetTester tester) async {
    await tester.tap(find.text('Add Ammunition').first);
    await tester.pumpAndSettle();
  }

  Future<void> selectWeaponGroup(WidgetTester tester, String group) async {
    final dropdown = find
        .byType(DropdownButtonFormField<WeaponGroup>)
        .hitTestable()
        .last;

    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text(group).last);
    await tester.pumpAndSettle();
  }

  Future<void> addAmmunition(
    WidgetTester tester, {
    String name = 'Arrows',
    String quantity = '20',
    bool selectBows = false,
  }) async {
    await openAddAmmunitionDialog(tester);

    await enterField(tester, 'Name', name);
    await enterField(tester, 'Quantity', quantity);

    if (selectBows) {
      await selectWeaponGroup(tester, 'Bows');
    }

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows Add Ammunition button when storage is empty', (
    tester,
  ) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    expect(find.text('Add Ammunition'), findsOneWidget);
    expect(find.text('AMMUNITION'), findsNothing);
  });

  testWidgets('opens the add ammunition dialog', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddAmmunitionDialog(tester);

    expect(find.text('Add Ammunition'), findsWidgets);
    expect(find.text('Compatible Weapon Group'), findsAtLeastNWidgets(1));
    expect(field('Name'), findsOneWidget);
    expect(field('Quantity'), findsOneWidget);
    expect(field('Ammunition Details'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('validates required fields before saving', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddAmmunitionDialog(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsAtLeastNWidgets(1));
    expect(find.text('Add Ammunition'), findsWidgets);
  });

  testWidgets('validates that quantity cannot be negative', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddAmmunitionDialog(tester);

    await enterField(tester, 'Name', 'Arrows');
    await enterField(tester, 'Quantity', '-1');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Minimum value is 0'), findsOneWidget);
    expect(find.text('Add Ammunition'), findsWidgets);
  });

  testWidgets('adds ammunition and displays its values', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addAmmunition(
      tester,
      name: 'Arrows',
      quantity: '20',
      selectBows: true,
    );

    expect(find.text('AMMUNITION'), findsOneWidget);
    expect(find.text('Arrows'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('Bows'), findsOneWidget);
  });

  testWidgets('adds ammunition without compatible groups', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addAmmunition(tester);

    expect(find.text('Arrows'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('Not specified'), findsOneWidget);
  });

  testWidgets('edits an existing ammunition stack', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addAmmunition(tester);

    await tester.tap(find.text('Arrows'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Ammunition'), findsOneWidget);

    await enterField(tester, 'Name', 'Steel Arrows');
    await enterField(tester, 'Quantity', '35');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Steel Arrows'), findsOneWidget);
    expect(find.text('35'), findsOneWidget);
    expect(find.text('Arrows'), findsNothing);
  });

  testWidgets('removes an ammunition stack', (tester) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await addAmmunition(tester);

    await tester.tap(find.byTooltip('Remove ammunition'));
    await tester.pumpAndSettle();

    expect(find.text('AMMUNITION'), findsNothing);
    expect(find.text('Arrows'), findsNothing);
    expect(find.text('Add Ammunition'), findsOneWidget);
  });

  testWidgets('allows selecting only one compatible weapon group', (
    tester,
  ) async {
    await setTestScreenSize(tester);
    await pumpSection(tester);

    await openAddAmmunitionDialog(tester);

    await enterField(tester, 'Name', 'Special Bolts');
    await enterField(tester, 'Quantity', '12');

    await selectWeaponGroup(tester, 'Bows');
    await selectWeaponGroup(tester, 'Light Blades');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Light Blades'), findsOneWidget);
    expect(find.text('Bows'), findsNothing);
  });
}
