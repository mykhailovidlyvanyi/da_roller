//lib/models/weapons/ranged_weapon.dart

import 'weapon.dart';
import 'reload_action.dart';

class RangedWeapon extends Weapon {
  final int shortRange;
  final int longRange;
  final ReloadAction reload;

  RangedWeapon({
    super.id,
    super.name = 'New Weapon',
    super.attackBonus = 0,
    super.damageDice = 1,
    super.damageModifier = 0,
    required this.shortRange,
    required this.longRange,
    required this.reload,
    super.details,
    super.weaponGroup,
    super.mainAttribute,
    super.minStrength,
    super.cost,
  });
}
