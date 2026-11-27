//lib/models/character/character_inventory.dart

import '../ammunition/ammunition_storage.dart';
import '../weapons/melee_weapon.dart';
import '../weapons/ranged_weapon.dart';

class CharacterInventory {
  final List<MeleeWeapon> meleeWeapons;
  final List<RangedWeapon> rangedWeapons;
  final AmmunitionStorage ammunitionStorage;

  const CharacterInventory({
    this.meleeWeapons = const [],
    this.rangedWeapons = const [],
    this.ammunitionStorage = const AmmunitionStorage(),
  });
}
