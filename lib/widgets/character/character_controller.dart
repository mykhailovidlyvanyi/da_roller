//lib/widgets/character/character_controller.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/dice/dice_roll.dart';
import 'package:da_roller/models/character/character_inventory.dart';
import 'package:da_roller/models/character/character_equipment.dart';
import 'package:da_roller/models/character/miscellaneous_item.dart';
import 'package:da_roller/models/weapons/melee_weapon.dart';
import 'package:da_roller/models/ammunition/ammunition_storage.dart';
import 'package:da_roller/models/weapons/ranged_weapon.dart';

import 'package:da_roller/widgets/character/character_sheet.dart';

class CharacterController extends StatefulWidget {
  final ValueChanged<DiceRoll> onRoll;

  const CharacterController({super.key, required this.onRoll});

  @override
  State<CharacterController> createState() => _CharacterControllerState();
}

class _CharacterControllerState extends State<CharacterController> {
  CharacterInventory _inventory = CharacterInventory();
  CharacterEquipment _equipment = const CharacterEquipment();

  void _updateAmmunitionStorage(AmmunitionStorage storage) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: storage,
        miscellaneousItems: _inventory.miscellaneousItems,
      );

      final equippedAmmunitionId = _equipment.equippedAmmunitionId;

      if (equippedAmmunitionId != null &&
          !storage.stacks.any((stack) => stack.id == equippedAmmunitionId)) {
        _equipment = CharacterEquipment(
          equippedMeleeWeaponId: _equipment.equippedMeleeWeaponId,
          equippedRangedWeaponId: _equipment.equippedRangedWeaponId,
          equippedAmmunitionId: null,
        );
      }
    });
  }

  void _addRangedWeapon(RangedWeapon weapon) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: [..._inventory.rangedWeapons, weapon],
        ammunitionStorage: _inventory.ammunitionStorage,
        miscellaneousItems: _inventory.miscellaneousItems,
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
        miscellaneousItems: _inventory.miscellaneousItems,
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
        miscellaneousItems: _inventory.miscellaneousItems,
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
        miscellaneousItems: _inventory.miscellaneousItems,
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
        miscellaneousItems: _inventory.miscellaneousItems,
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
        miscellaneousItems: _inventory.miscellaneousItems,
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

  void _addMiscellaneousItem(MiscellaneousItem item) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
        miscellaneousItems: [..._inventory.miscellaneousItems, item],
      );
    });
  }

  void _updateMiscellaneousItem(MiscellaneousItem updatedItem) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
        miscellaneousItems: _inventory.miscellaneousItems.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList(),
      );
    });
  }

  void _removeMiscellaneousItem(String itemId) {
    setState(() {
      _inventory = CharacterInventory(
        meleeWeapons: _inventory.meleeWeapons,
        rangedWeapons: _inventory.rangedWeapons,
        ammunitionStorage: _inventory.ammunitionStorage,
        miscellaneousItems: _inventory.miscellaneousItems
            .where((item) => item.id != itemId)
            .toList(),
      );
    });
  }

  void _setEquippedMeleeWeapon(String? weaponId) {
    setState(() {
      _equipment = CharacterEquipment(
        equippedMeleeWeaponId: weaponId,
        equippedRangedWeaponId: _equipment.equippedRangedWeaponId,
        equippedAmmunitionId: _equipment.equippedAmmunitionId,
      );
    });
  }

  void _setEquippedRangedWeapon(String? weaponId) {
    setState(() {
      _equipment = CharacterEquipment(
        equippedMeleeWeaponId: _equipment.equippedMeleeWeaponId,
        equippedRangedWeaponId: weaponId,
        equippedAmmunitionId: _equipment.equippedAmmunitionId,
      );
    });
  }

  void _setEquippedAmmunition(String? stackId) {
    setState(() {
      _equipment = CharacterEquipment(
        equippedMeleeWeaponId: _equipment.equippedMeleeWeaponId,
        equippedRangedWeaponId: _equipment.equippedRangedWeaponId,
        equippedAmmunitionId: stackId,
      );
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
      onAddMiscellaneousItem: _addMiscellaneousItem,
      onUpdateMiscellaneousItem: _updateMiscellaneousItem,
      onRemoveMiscellaneousItem: _removeMiscellaneousItem,
      onEquipMeleeWeapon: _setEquippedMeleeWeapon,
      onEquipRangedWeapon: _setEquippedRangedWeapon,
      onEquipAmmunition: _setEquippedAmmunition,
    );
  }
}
