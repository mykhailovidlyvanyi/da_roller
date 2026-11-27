//lib/widgets/character/character_controller.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice/dice_roll.dart';
import '../../models/character/character_inventory.dart';
import '../../models/character/character_equipment.dart';
import '../../models/weapons/melee_weapon.dart';
import '../../models/ammunition/ammunition_storage.dart';
import '../../models/weapons/ranged_weapon.dart';

import 'character_sheet.dart';

class CharacterController extends StatefulWidget {
  final ValueChanged<DiceRoll> onRoll;

  const CharacterController({super.key, required this.onRoll});

  @override
  State<CharacterController> createState() => _CharacterControllerState();
}

class _CharacterControllerState extends State<CharacterController> {
  CharacterInventory _inventory = const CharacterInventory();
  CharacterEquipment _equipment = const CharacterEquipment();

  void _updateAmmunitionStorage(AmmunitionStorage storage) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: storage,
      );
    });
  }

  void _addRangedWeapon(RangedWeapon weapon) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: [..._inventory.rangedWeapons, weapon],
        ammunitionStorage: _inventory.ammunitionStorage,
      );
    });
  }

  void _updateRangedWeapon(RangedWeapon updatedWeapon) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons.map((weapon) {
          return weapon.id == updatedWeapon.id ? updatedWeapon : weapon;
        }).toList(),
        ammunitionStorage: _inventory.ammunitionStorage,
      );
    });
  }

  void _removeRangedWeapon(String weaponId) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons
            .where((weapon) => weapon.id != weaponId)
            .toList(),
        ammunitionStorage: _inventory.ammunitionStorage,
      );

      if (_equipment.equippedRangedWeaponId == weaponId) {
        _equipment = CharacterEquipment(
          equippedMeleeWeaponId: _equipment.equippedMeleeWeaponId,
          equippedRangedWeaponId: null,
          equippedAmmunitionId: _equipment.equippedAmmunitionId,
        );
      }
    });
  }

  void _addMeleeWeapon(MeleeWeapon weapon) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: [..._inventory.meleeWeapons, weapon],
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
      );
    });
  }

  void _updateMeleeWeapon(MeleeWeapon updatedWeapon) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons.map((weapon) {
          return weapon.id == updatedWeapon.id ? updatedWeapon : weapon;
        }).toList(),
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
      );
    });
  }

  void _removeMeleeWeapon(String weaponId) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons
            .where((weapon) => weapon.id != weaponId)
            .toList(),
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
      );

      if (_equipment.equippedMeleeWeaponId == weaponId) {
        _equipment = CharacterEquipment(
          equippedMeleeWeaponId: null,
          equippedRangedWeaponId: _equipment.equippedRangedWeaponId,
          equippedAmmunitionId: _equipment.equippedAmmunitionId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CharacterSheet(
      onRoll: widget.onRoll,
      inventory: _inventory,
      equipment: _equipment,
      onAddMeleeWeapon: _addMeleeWeapon,
      onUpdateMeleeWeapon: _updateMeleeWeapon,
      onRemoveMeleeWeapon: _removeMeleeWeapon,
      onAmmunitionStorageChanged: _updateAmmunitionStorage,
      onAddRangedWeapon: _addRangedWeapon,
      onUpdateRangedWeapon: _updateRangedWeapon,
      onRemoveRangedWeapon: _removeRangedWeapon,
    );
  }
}
