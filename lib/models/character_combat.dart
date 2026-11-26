//lib/models/character_combat.dart

class CharacterCombat {
  int defence;
  int shieldBonus;
  bool shieldActive;

  int armor;
  int armorPenalty;

  int speed;

  int maxHealth;
  int currentHealth;

  int? maxMana;
  int? currentMana;

  int? damageTaken;
  bool includeArmor;

  CharacterCombat({
    this.defence = 10,
    this.shieldBonus = 0,
    this.shieldActive = false,
    this.armor = 0,
    this.armorPenalty = 0,
    this.speed = 10,
    this.maxHealth = 30,
    this.currentHealth = 30,
    this.maxMana,
    this.currentMana,
    this.damageTaken,
    this.includeArmor = true,
  });

  int get charge => speed ~/ 2;

  int get run => speed * 2;
}
