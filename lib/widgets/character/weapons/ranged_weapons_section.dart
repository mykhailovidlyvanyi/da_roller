//lib/widgets/character/weapons/ranged_weapons_section.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/weapons/ranged_weapon.dart';
import 'package:da_roller/models/weapons/reload_action.dart';
import 'package:da_roller/models/dice/dice_roll.dart';

import 'package:da_roller/widgets/character/common/range_weapon_editor.dart';
import 'package:da_roller/widgets/character/common/editable_value_cell.dart';
import 'package:da_roller/widgets/character/common/header_cell.dart';
import 'package:da_roller/widgets/character/common/editable_item_row.dart';

class RangedWeaponsSection extends StatelessWidget {
  final List<RangedWeapon> weapons;
  final ValueChanged<RangedWeapon> onAddWeapon;
  final ValueChanged<RangedWeapon> onUpdateWeapon;
  final ValueChanged<String> onRemoveWeapon;
  final ValueChanged<DiceRoll> onRoll;
  final String? equippedWeaponId;
  final ValueChanged<String?> onEquipWeapon;

  const RangedWeaponsSection({
    super.key,
    required this.weapons,
    required this.onAddWeapon,
    required this.onUpdateWeapon,
    required this.onRemoveWeapon,
    required this.onRoll,
    required this.equippedWeaponId,
    required this.onEquipWeapon,
  });

  static const double _weaponRowHeight = 80;

  Future<void> _editWeapon(
    BuildContext context, {
    RangedWeapon? existingWeapon,
  }) async {
    final weapon = await RangedWeaponEditor.show(
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

  String _reloadActionLabel(ReloadAction action) {
    switch (action) {
      case ReloadAction.majorAction:
        return 'Major Action';
      case ReloadAction.minorAction:
        return 'Minor Action';
      case ReloadAction.none:
        return 'N/A';
    }
  }

  Widget _weaponRow(BuildContext context, RangedWeapon weapon) {
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
        EditableValueCell(
          value: '${weapon.shortRange}/${weapon.longRange}',
          flex: 2,
          onTap: () => _editWeapon(context, existingWeapon: weapon),
        ),
        EditableValueCell(
          value: _reloadActionLabel(weapon.reload),
          flex: 2,
          onTap: () => _editWeapon(context, existingWeapon: weapon),
        ),
        SizedBox(
          width: 88,
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
            ],
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 28, height: 36),
          tooltip: 'Remove weapon',
          onPressed: () => onRemoveWeapon(weapon.id),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white38,
            size: 17,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: equippedWeaponId != null
                        ? TextButton(
                            onPressed: () => onEquipWeapon(null),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.white54,
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: const Text('Unequip'),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                HeaderCell(text: 'RANGED WEAPONS', flex: 3),
                HeaderCell(text: 'ATTACK', flex: 1),
                HeaderCell(text: 'DAMAGE', flex: 2),
                HeaderCell(text: 'RANGE', flex: 2),
                HeaderCell(text: 'RELOAD', flex: 2),
                const SizedBox(width: 116),
              ],
            ),
          ),
          if (weapons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No ranged weapons added',
                  style: TextStyle(color: Colors.white30, fontSize: 12),
                ),
              ),
            )
          else
            RadioGroup<String>(
              groupValue: equippedWeaponId,
              onChanged: onEquipWeapon,
              child: SizedBox(
                height:
                    _weaponRowHeight *
                    (displayedWeapons.length > 3 ? 3 : displayedWeapons.length),
                child: ListView.builder(
                  itemCount: displayedWeapons.length,
                  itemExtent: _weaponRowHeight,
                  itemBuilder: (context, index) =>
                      _weaponRow(context, displayedWeapons[index]),
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
