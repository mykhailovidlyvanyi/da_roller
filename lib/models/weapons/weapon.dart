//lib/models/weapons/weapon.dart

import 'package:uuid/uuid.dart';

import 'weapon_group.dart';
import 'weapon_attribute.dart';

const _uuid = Uuid();

abstract class Weapon {
  final String id;
  final String name;
  final int attackBonus;
  final int damageDice;
  final int damageModifier;
  final String details;

  final WeaponGroup? weaponGroup;
  final WeaponAttribute? mainAttribute;
  final int? minStrength;
  final int? cost;

  Weapon({
    String? id,
    required this.name,
    required this.attackBonus,
    required this.damageDice,
    required this.damageModifier,
    this.details = '',
    this.weaponGroup,
    this.mainAttribute,
    this.minStrength,
    this.cost,
  }) : id = id ?? _uuid.v4();
}
