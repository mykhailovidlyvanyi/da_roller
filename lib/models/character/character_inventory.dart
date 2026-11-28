//lib/models/character/character_inventory.dart

import 'miscellaneous_item.dart';
import '../ammunition/ammunition_storage.dart';
import '../weapons/melee_weapon.dart';
import '../weapons/ranged_weapon.dart';
import '../weapons/weapon_attribute.dart';
import '../weapons/weapon_group.dart';

class CharacterInventory {
  final List<MeleeWeapon> meleeWeapons;
  final List<RangedWeapon> rangedWeapons;
  final AmmunitionStorage ammunitionStorage;
  final List<MiscellaneousItem> miscellaneousItems;

  CharacterInventory({
    List<MeleeWeapon>? meleeWeapons,
    this.rangedWeapons = const [],
    this.ammunitionStorage = const AmmunitionStorage(),
    this.miscellaneousItems = const [],
  }) : meleeWeapons =
           meleeWeapons ??
           [
             MeleeWeapon(
               name: 'Fists',
               attackBonus: 0,
               damageDice: 1,
               damageModifier: 0,
               weaponGroup: WeaponGroup.brawling,
               mainAttribute: WeaponAttribute.strength,
               minStrength: null,
               cost: 0,
             ),
           ];
}
