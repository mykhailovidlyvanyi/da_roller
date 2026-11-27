//lib/widgets/character/weapons/ranged_weapons_section.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/weapons/ranged_weapon.dart';
import '../../../models/weapons/weapon_group.dart';
import '../../../models/weapons/weapon_attribute.dart';
import '../../../models/weapons/reload_action.dart';

import '../../../models/dice/dice_roll.dart';

import '../common/form_dropdown.dart';
import '../common/form_input.dart';
import '../common/editable_value_cell.dart';
import '../common/header_cell.dart';
import '../common/editable_item_row.dart';

class RangedWeaponsSection extends StatelessWidget {
  final List<RangedWeapon> weapons;
  final ValueChanged<RangedWeapon> onAddWeapon;
  final ValueChanged<RangedWeapon> onUpdateWeapon;
  final ValueChanged<String> onRemoveWeapon;
  final ValueChanged<DiceRoll> onRoll;

  const RangedWeaponsSection({
    super.key,
    required this.weapons,
    required this.onAddWeapon,
    required this.onUpdateWeapon,
    required this.onRemoveWeapon,
    required this.onRoll,
  });

  static const double _weaponRowHeight = 80;

  Future<void> _editWeapon(
    BuildContext context, {
    RangedWeapon? existingWeapon,
  }) async {
    final nameController = TextEditingController(
      text: existingWeapon?.name ?? '',
    );
    final attackBonusController = TextEditingController(
      text: (existingWeapon?.attackBonus ?? 0).toString(),
    );
    final damageDiceController = TextEditingController(
      text: (existingWeapon?.damageDice ?? 1).toString(),
    );
    final damageModifierController = TextEditingController(
      text: (existingWeapon?.damageModifier ?? 0).toString(),
    );
    final shortRangeController = TextEditingController(
      text: existingWeapon?.shortRange.toString() ?? '',
    );
    final longRangeController = TextEditingController(
      text: existingWeapon?.longRange.toString() ?? '',
    );
    final detailsController = TextEditingController(
      text: existingWeapon?.details ?? '',
    );
    final minStrengthController = TextEditingController(
      text: existingWeapon?.minStrength?.toString() ?? '',
    );
    final costController = TextEditingController(
      text: existingWeapon?.cost?.toString() ?? '',
    );

    WeaponGroup? selectedWeaponGroup = existingWeapon?.weaponGroup;
    WeaponAttribute? selectedMainAttribute = existingWeapon?.mainAttribute;
    ReloadAction selectedReload = existingWeapon?.reload ?? ReloadAction.none;

    final formKey = GlobalKey<FormState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = (screenWidth - 128).clamp(160.0, 512.0);
    final isWide = contentWidth >= 440;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            existingWeapon == null ? 'Add Ranged Weapon' : 'Edit Ranged Weapon',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: contentWidth,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormInput(
                              controller: nameController,
                              label: 'Name',
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormInput(
                              controller: attackBonusController,
                              label: 'Attack Bonus',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                  ),
                              isRequired: true,
                              isInteger: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: _buildDamageInputs(
                              damageDiceController,
                              damageModifierController,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          FormInput(
                            controller: nameController,
                            label: 'Name',
                            isRequired: true,
                          ),
                          const SizedBox(height: 8),
                          FormInput(
                            controller: attackBonusController,
                            label: 'Attack Bonus',
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                            ),
                            isRequired: true,
                            isInteger: true,
                          ),
                          const SizedBox(height: 8),
                          _buildDamageInputs(
                            damageDiceController,
                            damageModifierController,
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormInput(
                              controller: shortRangeController,
                              label: 'Short Range',
                              keyboardType: TextInputType.number,
                              isRequired: true,
                              isInteger: true,
                              minValue: 0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormInput(
                              controller: longRangeController,
                              label: 'Long Range',
                              keyboardType: TextInputType.number,
                              isRequired: true,
                              isInteger: true,
                              minValue: 0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormDropdown<ReloadAction>(
                              value: selectedReload,
                              label: 'Reload',
                              items: ReloadAction.values,
                              itemLabel: _reloadActionLabel,
                              onChanged: (value) {
                                if (value == null) return;
                                setDialogState(() {
                                  selectedReload = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          FormInput(
                            controller: shortRangeController,
                            label: 'Short Range',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            isInteger: true,
                            minValue: 0,
                          ),
                          const SizedBox(height: 8),
                          FormInput(
                            controller: longRangeController,
                            label: 'Long Range',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            isInteger: true,
                            minValue: 0,
                          ),
                          const SizedBox(height: 8),
                          FormDropdown<ReloadAction>(
                            value: selectedReload,
                            label: 'Reload',
                            items: ReloadAction.values,
                            itemLabel: _reloadActionLabel,
                            onChanged: (value) {
                              if (value == null) return;
                              setDialogState(() {
                                selectedReload = value;
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormDropdown<WeaponGroup>(
                              value: selectedWeaponGroup,
                              label: 'Weapon Group',
                              items: WeaponGroup.rangedGroups,
                              itemLabel: _weaponGroupLabel,
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedWeaponGroup = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormDropdown<WeaponAttribute>(
                              value: selectedMainAttribute,
                              label: 'Main Attribute',
                              items: WeaponAttribute.values,
                              itemLabel: _weaponAttributeLabel,
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedMainAttribute = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          FormDropdown<WeaponGroup>(
                            value: selectedWeaponGroup,
                            label: 'Weapon Group',
                            items: WeaponGroup.rangedGroups,
                            itemLabel: _weaponGroupLabel,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedWeaponGroup = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          FormDropdown<WeaponAttribute>(
                            value: selectedMainAttribute,
                            label: 'Main Attribute',
                            items: WeaponAttribute.values,
                            itemLabel: _weaponAttributeLabel,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedMainAttribute = value;
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 8),

                    if (isWide)
                      Row(
                        children: [
                          Expanded(
                            child: FormInput(
                              controller: minStrengthController,
                              label: 'Min Strength',
                              keyboardType: TextInputType.number,
                              isInteger: true,
                              minValue: 0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FormInput(
                              controller: costController,
                              label: 'Cost',
                              keyboardType: TextInputType.number,
                              isInteger: true,
                              minValue: 0,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          FormInput(
                            controller: minStrengthController,
                            label: 'Min Strength',
                            keyboardType: TextInputType.number,
                            isInteger: true,
                            minValue: 0,
                          ),
                          const SizedBox(height: 8),
                          FormInput(
                            controller: costController,
                            label: 'Cost',
                            keyboardType: TextInputType.number,
                            isInteger: true,
                            minValue: 0,
                          ),
                        ],
                      ),

                    const SizedBox(height: 8),

                    FormInput(
                      controller: detailsController,
                      label: 'Weapon Details',
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final weapon = RangedWeapon(
        id: existingWeapon?.id,
        name: nameController.text.trim(),
        attackBonus: int.parse(attackBonusController.text.trim()),
        damageDice: int.parse(damageDiceController.text.trim()),
        damageModifier: int.parse(damageModifierController.text.trim()),
        shortRange: int.parse(shortRangeController.text.trim()),
        longRange: int.parse(longRangeController.text.trim()),
        reload: selectedReload,
        details: detailsController.text.trim(),
        weaponGroup: selectedWeaponGroup,
        mainAttribute: selectedMainAttribute,
        minStrength: int.tryParse(minStrengthController.text.trim()),
        cost: int.tryParse(costController.text.trim()),
      );

      if (existingWeapon == null) {
        onAddWeapon(weapon);
      } else {
        onUpdateWeapon(weapon);
      }
    }

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      nameController.dispose();
      attackBonusController.dispose();
      damageDiceController.dispose();
      damageModifierController.dispose();
      shortRangeController.dispose();
      longRangeController.dispose();
      detailsController.dispose();
      minStrengthController.dispose();
      costController.dispose();
    });
  }

  String _weaponGroupLabel(WeaponGroup group) {
    switch (group) {
      case WeaponGroup.axes:
        return 'Axes';
      case WeaponGroup.bludgeons:
        return 'Bludgeons';
      case WeaponGroup.bows:
        return 'Bows';
      case WeaponGroup.brawling:
        return 'Brawling';
      case WeaponGroup.heavyBlades:
        return 'Heavy Blades';
      case WeaponGroup.lightBlades:
        return 'Light Blades';
      case WeaponGroup.spear:
        return 'Spear';
      case WeaponGroup.staves:
        return 'Staves';
    }
  }

  String _weaponAttributeLabel(WeaponAttribute attribute) {
    switch (attribute) {
      case WeaponAttribute.strength:
        return 'Strength';
      case WeaponAttribute.dexterity:
        return 'Dexterity';
      case WeaponAttribute.magic:
        return 'Magic';
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

  Widget _buildDamageInputs(
    TextEditingController diceController,
    TextEditingController modifierController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FormInput(
            controller: diceController,
            label: 'Damage',
            keyboardType: TextInputType.number,
            isRequired: true,
            isInteger: true,
            minValue: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          child: Text(
            'd6',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: FormInput(
            controller: modifierController,
            label: 'Damage',
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            isRequired: true,
            isInteger: true,
          ),
        ),
      ],
    );
  }

  Widget _weaponRow(BuildContext context, RangedWeapon weapon) {
    return EditableItemRow(
      cells: [
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
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
            SizedBox(
              height:
                  _weaponRowHeight * (weapons.length > 3 ? 3 : weapons.length),
              child: ListView.builder(
                itemCount: weapons.length,
                itemExtent: _weaponRowHeight,
                itemBuilder: (context, index) =>
                    _weaponRow(context, weapons[index]),
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
