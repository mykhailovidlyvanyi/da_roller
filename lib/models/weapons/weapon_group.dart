//lib/models/weapons/weapon_group.dart

enum WeaponGroup {
  axes,
  bludgeons,
  bows,
  brawling,
  heavyBlades,
  lightBlades,
  spear,
  staves;

  static const List<WeaponGroup> meleeGroups = [
    axes,
    bludgeons,
    brawling,
    heavyBlades,
    lightBlades,
    spear,
    staves,
  ];

  static const List<WeaponGroup> rangedGroups = [bows, staves, lightBlades];
}
