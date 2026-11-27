//lib/models/dice/melee_weapon.dart

class MeleeWeapon {
  String name;
  int attackBonus;
  int damageDice;
  int damageModifier;
  String details;

  MeleeWeapon({
    this.name = 'New Weapon',
    this.attackBonus = 0,
    this.damageDice = 1,
    this.damageModifier = 0,
    this.details = '',
  });
}
