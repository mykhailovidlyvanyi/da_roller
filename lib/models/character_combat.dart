//lib/models/character_combat.dart

class CharacterCombat {
  int defence;
  int shieldBonus;
  bool shieldActive;

  int armor;
  int armorPenalty;

  int speed;

  int _maxHealth;
  int _currentHealth;

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
    int maxHealth = 30,
    int currentHealth = 30,
    this.maxMana,
    this.currentMana,
    this.damageTaken,
    this.includeArmor = true,
  }) : _maxHealth = maxHealth < 0 ? 0 : maxHealth,
       _currentHealth = currentHealth.clamp(0, maxHealth < 0 ? 0 : maxHealth);

  int get maxHealth => _maxHealth;

  set maxHealth(int value) {
    _maxHealth = value < 0 ? 0 : value;
    _currentHealth = _currentHealth.clamp(0, _maxHealth);
  }

  int get currentHealth => _currentHealth;

  set currentHealth(int value) {
    _currentHealth = value.clamp(0, _maxHealth);
  }

  int get charge => speed ~/ 2;

  int get run => speed * 2;
}
