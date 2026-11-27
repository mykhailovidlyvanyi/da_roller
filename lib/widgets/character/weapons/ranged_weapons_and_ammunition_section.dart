//lib/widgets/character/weapons/ranged_weapons_and_ammunition_section.dart
import 'package:material_ui/material_ui.dart';

import '../../../models/ammunition/ammunition_storage.dart';
import '../../../models/dice/dice_roll.dart';
import '../../../models/weapons/ranged_weapon.dart';

import 'ammunition_storage_section.dart';
import 'ranged_weapons_section.dart';

class RangedWeaponsAndAmmunitionSection extends StatelessWidget {
  final ValueChanged<DiceRoll> onRoll;

  final AmmunitionStorage storage;
  final ValueChanged<AmmunitionStorage> onStorageChanged;

  final List<RangedWeapon> weapons;
  final ValueChanged<RangedWeapon> onAddWeapon;
  final ValueChanged<RangedWeapon> onUpdateWeapon;
  final ValueChanged<String> onRemoveWeapon;

  const RangedWeaponsAndAmmunitionSection({
    super.key,
    required this.onRoll,
    required this.storage,
    required this.onStorageChanged,
    required this.weapons,
    required this.onAddWeapon,
    required this.onUpdateWeapon,
    required this.onRemoveWeapon,
  });

  @override
  Widget build(BuildContext context) {
    final hasAmmunition = storage.stacks.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;

        final rangedWeapons = RangedWeaponsSection(
          weapons: weapons,
          onAddWeapon: onAddWeapon,
          onUpdateWeapon: onUpdateWeapon,
          onRemoveWeapon: onRemoveWeapon,
          onRoll: onRoll,
        );

        final ammunition = AmmunitionStorageSection(
          storage: storage,
          onStorageChanged: onStorageChanged,
          expandToFill: !isNarrow,
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [rangedWeapons, const SizedBox(height: 8), ammunition],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: hasAmmunition ? 7 : 9, child: rangedWeapons),
              const SizedBox(width: 8),
              Expanded(flex: hasAmmunition ? 3 : 1, child: ammunition),
            ],
          ),
        );
      },
    );
  }
}
