//lib/models/character/character_equipment.dart

class CharacterEquipment {
  final String? equippedMeleeWeaponId;
  final String? equippedRangedWeaponId;
  final String? equippedAmmunitionId;

  const CharacterEquipment({
    this.equippedMeleeWeaponId,
    this.equippedRangedWeaponId,
    this.equippedAmmunitionId,
  });
}
