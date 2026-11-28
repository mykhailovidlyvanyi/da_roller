//lib/widgets/character/common/range_weapon_editor.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/weapons/ranged_weapon.dart';
import 'package:da_roller/models/weapons/weapon_group.dart';
import 'package:da_roller/models/weapons/weapon_attribute.dart';
import 'package:da_roller/models/weapons/reload_action.dart';

import 'package:da_roller/widgets/character/common/form_dropdown.dart';
import 'package:da_roller/widgets/character/common/form_input.dart';

class RangedWeaponEditor {
  static Future<RangedWeapon?> show(
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

    try {
      final screenWidth = MediaQuery.of(context).size.width;
      final contentWidth = (screenWidth - 128).clamp(160.0, 512.0);
      final isWide = contentWidth >= 440;

      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              existingWeapon == null
                  ? 'Add Ranged Weapon'
                  : 'Edit Ranged Weapon',
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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

      if (result != true) return null;

      return RangedWeapon(
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
    } finally {
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
  }

  static String _weaponGroupLabel(WeaponGroup group) {
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

  static String _weaponAttributeLabel(WeaponAttribute attribute) {
    switch (attribute) {
      case WeaponAttribute.strength:
        return 'Strength';
      case WeaponAttribute.dexterity:
        return 'Dexterity';
      case WeaponAttribute.magic:
        return 'Magic';
    }
  }

  static String _reloadActionLabel(ReloadAction action) {
    switch (action) {
      case ReloadAction.majorAction:
        return 'Major Action';
      case ReloadAction.minorAction:
        return 'Minor Action';
      case ReloadAction.none:
        return 'N/A';
    }
  }

  static Widget _buildDamageInputs(
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
}
