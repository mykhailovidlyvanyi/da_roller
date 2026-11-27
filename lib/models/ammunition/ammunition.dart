//lib/models/ammunition/ammunition.dart

import '../weapons/weapon_group.dart';

class Ammunition {
  final String name;
  final String details;
  final List<WeaponGroup> compatibleWeaponGroups;

  const Ammunition({
    required this.name,
    this.details = '',
    this.compatibleWeaponGroups = const [],
  });
}
