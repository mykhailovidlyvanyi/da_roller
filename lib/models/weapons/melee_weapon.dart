//lib/models/weapons/melee_weapon.dart

import 'weapon.dart';

class MeleeWeapon extends Weapon {
  MeleeWeapon({
    super.id,
    super.name = 'New Weapon',
    super.attackBonus = 0,
    super.damageDice = 1,
    super.damageModifier = 0,
    super.details,
    super.weaponGroup,
    super.mainAttribute,
    super.minStrength,
    super.cost,
  });
}
