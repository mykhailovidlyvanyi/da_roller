//lib/widgets/character/combat_section.dart

import 'package:material_ui/material_ui.dart';

import '../../models/character_combat.dart';
import 'combat_column.dart';
import 'combat_stat_card.dart';
import 'section_title.dart';

class CombatSection extends StatefulWidget {
  const CombatSection({super.key});

  @override
  State<CombatSection> createState() => _CombatSectionState();
}

class _CombatSectionState extends State<CombatSection> {
  final CharacterCombat _combat = CharacterCombat();

  void _applyDamage(int? damageTaken) {
    setState(() {
      if (damageTaken != null) {
        final damage = _combat.includeArmor
            ? damageTaken - (_combat.armor - _combat.armorPenalty)
            : damageTaken;

        _combat.currentHealth -= damage.clamp(0, _combat.currentHealth);
      }

      _combat.damageTaken = null;
    });
  }

  Widget _stat({
    Key? key,
    required String title,
    required int? value,
    required ValueChanged<int?> onChanged,
    bool editable = true,
  }) {
    return CombatStatCard(
      key: key,
      title: title,
      value: value,
      isEditable: editable,
      onValueChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'COMBAT', subtitle: 'Combat statistics'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children: [
            CombatColumn(
              title: 'DEFENSE',
              children: [
                _stat(
                  title: 'Defence',
                  value: _combat.defence,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.defence = v);
                    }
                  },
                ),
                _stat(
                  title: 'Shield bonus',
                  value: _combat.shieldBonus,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.shieldBonus = v);
                    }
                  },
                ),
                CombatStatCard(
                  title: 'Shield active',
                  isToggle: true,
                  toggleValue: _combat.shieldActive,
                  onToggleChanged: (v) {
                    setState(() => _combat.shieldActive = v);
                  },
                ),
              ],
            ),
            CombatColumn(
              title: 'ARMOR',
              children: [
                _stat(
                  title: 'Armor',
                  value: _combat.armor,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.armor = v);
                    }
                  },
                ),
                _stat(
                  title: 'Armor penalty',
                  value: _combat.armorPenalty,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.armorPenalty = v);
                    }
                  },
                ),
              ],
            ),
            CombatColumn(
              title: 'MOVEMENT',
              children: [
                _stat(
                  key: const ValueKey('combat_speed'),
                  title: 'Speed',
                  value: _combat.speed,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.speed = v);
                    }
                  },
                ),
                _stat(
                  title: 'Charge',
                  value: _combat.charge,
                  onChanged: (_) {},
                  editable: false,
                ),
                _stat(
                  title: 'Run',
                  value: _combat.run,
                  onChanged: (_) {},
                  editable: false,
                ),
              ],
            ),
            CombatColumn(
              title: 'HEALTH',
              children: [
                _stat(
                  title: 'Max health',
                  value: _combat.maxHealth,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.maxHealth = v);
                    }
                  },
                ),
                _stat(
                  title: 'Current health',
                  value: _combat.currentHealth,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _combat.currentHealth = v);
                    }
                  },
                ),
              ],
            ),
            CombatColumn(
              title: 'MANA',
              children: [
                _stat(
                  title: 'Max mana',
                  value: _combat.maxMana,
                  onChanged: (v) {
                    setState(() => _combat.maxMana = v);
                  },
                ),
                _stat(
                  title: 'Current mana',
                  value: _combat.currentMana,
                  onChanged: (v) {
                    setState(() => _combat.currentMana = v);
                  },
                ),
              ],
            ),
            CombatColumn(
              title: 'DAMAGE',
              children: [
                CombatStatCard(
                  title: 'Damage taken',
                  value: _combat.damageTaken,
                  isAlwaysEditing: true,
                  onValueChanged: _applyDamage,
                ),
                CombatStatCard(
                  title: 'Include armor',
                  isToggle: true,
                  toggleValue: _combat.includeArmor,
                  onToggleChanged: (v) {
                    setState(() => _combat.includeArmor = v);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
