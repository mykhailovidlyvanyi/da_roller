// lib/widgets/character/character_sheet.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice/dice_roll.dart';
import '../../models/character/character_inventory.dart';
import '../../models/character/character_equipment.dart';
import '../../models/weapons/melee_weapon.dart';
import '../../models/weapons/ranged_weapon.dart';

import '../../models/ammunition/ammunition_storage.dart';

import 'attributes/attributes_section.dart';

import 'character_info/character_header.dart';
import 'character_info/character_info_section.dart';

import 'combat/combat_section.dart';

import 'weapons/melee_weapons_section.dart';
import 'weapons/ranged_weapons_and_ammunition_section.dart';

import 'common/section_title.dart';
import 'common/placeholder_section.dart';

class CharacterSheet extends StatefulWidget {
  final ValueChanged<DiceRoll> onRoll;
  final CharacterInventory inventory;
  final CharacterEquipment equipment;

  final ValueChanged<MeleeWeapon> onAddMeleeWeapon;
  final ValueChanged<MeleeWeapon> onUpdateMeleeWeapon;
  final ValueChanged<String> onRemoveMeleeWeapon;

  final ValueChanged<RangedWeapon> onAddRangedWeapon;
  final ValueChanged<RangedWeapon> onUpdateRangedWeapon;
  final ValueChanged<String> onRemoveRangedWeapon;

  final ValueChanged<AmmunitionStorage> onAmmunitionStorageChanged;

  const CharacterSheet({
    super.key,
    required this.onRoll,
    required this.inventory,
    required this.equipment,
    required this.onAddMeleeWeapon,
    required this.onUpdateMeleeWeapon,
    required this.onRemoveMeleeWeapon,
    required this.onAmmunitionStorageChanged,
    required this.onAddRangedWeapon,
    required this.onUpdateRangedWeapon,
    required this.onRemoveRangedWeapon,
  });

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  int _dexterity = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: AttributesSection(
            onRoll: widget.onRoll,
            onDexterityChanged: (value) {
              setState(() {
                _dexterity = value;
              });
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 24, 20, 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CharacterHeader(),

                const SizedBox(height: 24),

                const CharacterInfoSection(),

                const SizedBox(height: 32),

                CombatSection(dexterity: _dexterity),

                const SizedBox(height: 20),

                MeleeWeaponsSection(
                  weapons: widget.inventory.meleeWeapons,
                  onAddWeapon: widget.onAddMeleeWeapon,
                  onUpdateWeapon: widget.onUpdateMeleeWeapon,
                  onRemoveWeapon: widget.onRemoveMeleeWeapon,
                  onRoll: widget.onRoll,
                ),

                const SizedBox(height: 16),

                RangedWeaponsAndAmmunitionSection(
                  onRoll: widget.onRoll,
                  weapons: widget.inventory.rangedWeapons,
                  onAddWeapon: widget.onAddRangedWeapon,
                  onUpdateWeapon: widget.onUpdateRangedWeapon,
                  onRemoveWeapon: widget.onRemoveRangedWeapon,
                  storage: widget.inventory.ammunitionStorage,
                  onStorageChanged: widget.onAmmunitionStorageChanged,
                ),

                const SizedBox(height: 32),

                const SectionTitle(title: 'ABILITIES & TALENTS'),

                const SizedBox(height: 12),

                const PlaceholderSection(
                  text: 'Abilities and talents will appear here',
                ),

                const SizedBox(height: 24),

                const SectionTitle(title: 'EQUIPMENT'),

                const SizedBox(height: 12),

                const PlaceholderSection(text: 'Weapons, armor and equipment'),

                const SizedBox(height: 24),

                const SectionTitle(title: 'NOTES'),

                const SizedBox(height: 12),

                const PlaceholderSection(
                  text: 'Character notes and background',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
