//lib/widgets/character/weapons/ranged_weapons_and_ammunition_section.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/ammunition/ammunition_storage.dart';
import '../../../models/dice/dice_roll.dart';
import 'ammunition_storage_section.dart';
import 'ranged_weapons_section.dart';

class RangedWeaponsAndAmmunitionSection extends StatefulWidget {
  final ValueChanged<DiceRoll> onRoll;

  const RangedWeaponsAndAmmunitionSection({super.key, required this.onRoll});

  @override
  State<RangedWeaponsAndAmmunitionSection> createState() =>
      _RangedWeaponsAndAmmunitionSectionState();
}

class _RangedWeaponsAndAmmunitionSectionState
    extends State<RangedWeaponsAndAmmunitionSection> {
  AmmunitionStorage _storage = const AmmunitionStorage();

  void _updateStorage(AmmunitionStorage storage) {
    setState(() {
      _storage = storage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAmmunition = _storage.stacks.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: hasAmmunition ? 7 : 9,
            child: RangedWeaponsSection(onRoll: widget.onRoll),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: hasAmmunition ? 3 : 1,
            child: AmmunitionStorageSection(
              storage: _storage,
              onStorageChanged: _updateStorage,
            ),
          ),
        ],
      ),
    );
  }
}
