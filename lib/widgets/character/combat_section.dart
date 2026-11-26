//lib/widgets/character/combat_section_test.dart

import 'package:material_ui/material_ui.dart';

import 'combat_column.dart';
import 'combat_stat_card.dart';
import 'section_title.dart';

class CombatSection extends StatefulWidget {
  const CombatSection({super.key});

  @override
  State<CombatSection> createState() => _CombatSectionState();
}

class _CombatSectionState extends State<CombatSection> {
  int defence = 12;
  int shieldBonus = 2;
  bool shieldActive = false;

  int armor = 5;
  int armorPenalty = -2;

  int speed = 30;

  int maxHealth = 30;
  int currentHealth = 24;

  int maxMana = 20;
  int currentMana = 14;

  int damageTaken = 6;
  bool includeArmor = true;

  Widget _stat({
    Key? key,
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
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
                  value: defence,
                  onChanged: (v) => setState(() => defence = v),
                ),
                _stat(
                  title: 'Shield bonus',
                  value: shieldBonus,
                  onChanged: (v) => setState(() => shieldBonus = v),
                ),
                CombatStatCard(
                  title: 'Shield active',
                  isToggle: true,
                  toggleValue: shieldActive,
                  onToggleChanged: (v) => setState(() => shieldActive = v),
                ),
              ],
            ),

            CombatColumn(
              title: 'ARMOR',
              children: [
                _stat(
                  title: 'Armor',
                  value: armor,
                  onChanged: (v) => setState(() => armor = v),
                ),
                _stat(
                  title: 'Armor penalty',
                  value: armorPenalty,
                  onChanged: (v) => setState(() => armorPenalty = v),
                ),
              ],
            ),

            CombatColumn(
              title: 'MOVEMENT',
              children: [
                _stat(
                  key: const ValueKey('combat_speed'),
                  title: 'Speed',
                  value: speed,
                  onChanged: (v) => setState(() => speed = v),
                ),
                _stat(
                  title: 'Charge',
                  value: speed ~/ 2,
                  onChanged: (_) {},
                  editable: false,
                ),
                _stat(
                  title: 'Run',
                  value: speed * 2,
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
                  value: maxHealth,
                  onChanged: (v) => setState(() => maxHealth = v),
                ),
                _stat(
                  title: 'Current health',
                  value: currentHealth,
                  onChanged: (v) => setState(() => currentHealth = v),
                ),
              ],
            ),

            CombatColumn(
              title: 'MANA',
              children: [
                _stat(
                  title: 'Max mana',
                  value: maxMana,
                  onChanged: (v) => setState(() => maxMana = v),
                ),
                _stat(
                  title: 'Current mana',
                  value: currentMana,
                  onChanged: (v) => setState(() => currentMana = v),
                ),
              ],
            ),

            CombatColumn(
              title: 'DAMAGE',
              children: [
                CombatStatCard(
                  title: 'Damage taken',
                  value: damageTaken,
                  isAlwaysEditing: true,
                  onValueChanged: (v) {
                    setState(() => damageTaken = v);
                  },
                ),
                CombatStatCard(
                  title: 'Include armor',
                  isToggle: true,
                  toggleValue: includeArmor,
                  onToggleChanged: (v) {
                    setState(() => includeArmor = v);
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
