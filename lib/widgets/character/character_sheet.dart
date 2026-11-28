// lib/widgets/character/character_sheet.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/dice/dice_roll.dart';
import 'package:da_roller/models/character/character_inventory.dart';
import 'package:da_roller/models/character/character_equipment.dart';
import 'package:da_roller/models/character/miscellaneous_item.dart';
import 'package:da_roller/models/weapons/melee_weapon.dart';
import 'package:da_roller/models/weapons/ranged_weapon.dart';
import 'package:da_roller/models/ammunition/ammunition_storage.dart';

import 'package:da_roller/widgets/character/attributes/attributes_section.dart';
import 'package:da_roller/widgets/character/character_info/character_header.dart';
import 'package:da_roller/widgets/character/character_info/character_info_section.dart';
import 'package:da_roller/widgets/character/combat/combat_section.dart';
import 'package:da_roller/widgets/character/weapons/melee_weapons_section.dart';
import 'package:da_roller/widgets/character/weapons/ranged_weapons_and_ammunition_section.dart';
import 'package:da_roller/widgets/character/common/section_title.dart';
import 'package:da_roller/widgets/character/common/placeholder_section.dart';
import 'package:da_roller/widgets/character/inventory/inventory_section.dart';

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

  final ValueChanged<MiscellaneousItem> onAddMiscellaneousItem;
  final ValueChanged<MiscellaneousItem> onUpdateMiscellaneousItem;
  final ValueChanged<String> onRemoveMiscellaneousItem;

  final ValueChanged<AmmunitionStorage> onAmmunitionStorageChanged;

  final ValueChanged<String?> onEquipMeleeWeapon;
  final ValueChanged<String?> onEquipRangedWeapon;
  final ValueChanged<String?> onEquipAmmunition;

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
    required this.onAddMiscellaneousItem,
    required this.onUpdateMiscellaneousItem,
    required this.onRemoveMiscellaneousItem,
    required this.onEquipMeleeWeapon,
    required this.onEquipRangedWeapon,
    required this.onEquipAmmunition,
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
                  equippedWeaponId: widget.equipment.equippedMeleeWeaponId,
                  onEquipWeapon: widget.onEquipMeleeWeapon,
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
                  equippedWeaponId: widget.equipment.equippedRangedWeaponId,
                  onEquipWeapon: widget.onEquipRangedWeapon,
                  equippedAmmunitionId: widget.equipment.equippedAmmunitionId,
                  onEquipAmmunition: widget.onEquipAmmunition,
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
                InventorySection(
                  inventory: widget.inventory,
                  equipment: widget.equipment,
                  onAddMeleeWeapon: widget.onAddMeleeWeapon,
                  onAddRangedWeapon: widget.onAddRangedWeapon,
                  onRemoveMeleeWeapon: widget.onRemoveMeleeWeapon,
                  onRemoveRangedWeapon: widget.onRemoveRangedWeapon,
                  onAmmunitionStorageChanged: widget.onAmmunitionStorageChanged,
                  onEquipMeleeWeapon: widget.onEquipMeleeWeapon,
                  onEquipRangedWeapon: widget.onEquipRangedWeapon,
                  onEquipAmmunition: widget.onEquipAmmunition,
                  onUpdateMeleeWeapon: widget.onUpdateMeleeWeapon,
                  onUpdateRangedWeapon: widget.onUpdateRangedWeapon,
                  onAddMiscellaneousItem: widget.onAddMiscellaneousItem,
                  onUpdateMiscellaneousItem: widget.onUpdateMiscellaneousItem,
                  onRemoveMiscellaneousItem: widget.onRemoveMiscellaneousItem,
                ),
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
