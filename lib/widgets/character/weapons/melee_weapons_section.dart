//lib/widgets/character/weapons/melee_weapons_section.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/weapons/melee_weapon.dart';
import 'package:da_roller/models/dice/dice_roll.dart';

import 'package:da_roller/widgets/character/common/melee_weapon_editor.dart';
import 'package:da_roller/widgets/character/common/editable_value_cell.dart';
import 'package:da_roller/widgets/character/common/editable_item_row.dart';
import 'package:da_roller/widgets/character/common/table_header.dart';

class MeleeWeaponsSection extends StatelessWidget {
  final List<MeleeWeapon> weapons;
  final ValueChanged<MeleeWeapon> onAddWeapon;
  final ValueChanged<MeleeWeapon> onUpdateWeapon;
  final ValueChanged<String> onRemoveWeapon;
  final ValueChanged<DiceRoll> onRoll;
  final String? equippedWeaponId;
  final ValueChanged<String?> onEquipWeapon;

  const MeleeWeaponsSection({
    super.key,
    required this.weapons,
    required this.onAddWeapon,
    required this.onUpdateWeapon,
    required this.onRemoveWeapon,
    required this.onRoll,
    required this.equippedWeaponId,
    required this.onEquipWeapon,
  });

  static const double _weaponRowHeight = 76;

  Future<void> _editWeapon(
    BuildContext context, {
    MeleeWeapon? existingWeapon,
  }) async {
    final weapon = await MeleeWeaponEditor.show(
      context,
      existingWeapon: existingWeapon,
    );

    if (weapon == null) return;

    if (existingWeapon == null) {
      onAddWeapon(weapon);
    } else {
      onUpdateWeapon(weapon);
    }
  }

  Widget _weaponRow(BuildContext context, MeleeWeapon weapon) {
    return EditableItemRow(
      cells: [
        Expanded(
          flex: 2,
          child: Center(child: Radio<String>(value: weapon.id)),
        ),
        EditableValueCell(
          value: weapon.name,
          flex: 3,
          onTap: () => _editWeapon(context, existingWeapon: weapon),
        ),
        EditableValueCell(
          value: weapon.attackBonus >= 0
              ? '+${weapon.attackBonus}'
              : weapon.attackBonus.toString(),
          flex: 1,
          onTap: () => _editWeapon(context, existingWeapon: weapon),
        ),
        EditableValueCell(
          value:
              '${weapon.damageDice}d6'
              '${weapon.damageModifier == 0
                  ? ''
                  : weapon.damageModifier > 0
                  ? ' + ${weapon.damageModifier}'
                  : ' - ${weapon.damageModifier.abs()}'}',
          flex: 2,
          onTap: () => _editWeapon(context, existingWeapon: weapon),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                tooltip: 'Roll attack',
                onPressed: () {
                  onRoll(
                    DiceRoll(
                      type: DiceRollType.attack,
                      diceCount: 3,
                      modifier: weapon.attackBonus,
                      modifierLabel: 'Attack Bonus',
                    ),
                  );
                },
                icon: const Icon(
                  Icons.sports_martial_arts,
                  color: Colors.orangeAccent,
                  size: 19,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                tooltip: 'Roll damage',
                onPressed: () {
                  onRoll(
                    DiceRoll(
                      type: DiceRollType.damage,
                      diceCount: weapon.damageDice,
                      modifier: weapon.damageModifier,
                      modifierLabel: 'Damage Modifier',
                    ),
                  );
                },
                icon: const Icon(
                  Icons.heart_broken,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 36,
                ),
                tooltip: 'Remove weapon',
                onPressed: () => onRemoveWeapon(weapon.id),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white38,
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ],
      details: weapon.details,
      emptyDetailsText: 'Add weapon details...',
      onDetailsTap: () => _editWeapon(context, existingWeapon: weapon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedWeapons = [
      ...weapons.where((weapon) => weapon.id == equippedWeaponId),
      ...weapons.where((weapon) => weapon.id != equippedWeaponId),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383838)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableHeader(
            title: 'MELEE WEAPONS',
            showUnequip: equippedWeaponId != null,
            onUnequip: () => onEquipWeapon(null),
          ),
          if (weapons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No melee weapons added',
                  style: TextStyle(color: Colors.white30, fontSize: 12),
                ),
              ),
            )
          else
            SizedBox(
              height:
                  _weaponRowHeight * (weapons.length > 3 ? 3 : weapons.length),
              child: RadioGroup<String>(
                groupValue: equippedWeaponId,
                onChanged: (value) {
                  onEquipWeapon(value);
                },
                child: SizedBox(
                  height:
                      _weaponRowHeight *
                      (displayedWeapons.length > 3
                          ? 3
                          : displayedWeapons.length),
                  child: ListView.builder(
                    itemCount: displayedWeapons.length,
                    itemExtent: _weaponRowHeight,
                    itemBuilder: (context, index) =>
                        _weaponRow(context, displayedWeapons[index]),
                  ),
                ),
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF383838))),
            ),
            child: TextButton.icon(
              onPressed: () => _editWeapon(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Weapon'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
