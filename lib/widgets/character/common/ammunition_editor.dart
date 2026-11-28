//lib/widgets/character/common/ammunition_editor.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/ammunition/ammunition.dart';
import 'package:da_roller/models/ammunition/ammunition_stack.dart';
import 'package:da_roller/models/weapons/weapon_group.dart';

import 'package:da_roller/widgets/character/common/form_dropdown.dart';
import 'package:da_roller/widgets/character/common/form_input.dart';

class AmmunitionEditor {
  static Future<AmmunitionStack?> show(
    BuildContext context, {
    AmmunitionStack? existingStack,
  }) async {
    final existingAmmunition = existingStack?.ammunition;

    final nameController = TextEditingController(
      text: existingAmmunition?.name ?? '',
    );
    final quantityController = TextEditingController(
      text: (existingStack?.quantity ?? 1).toString(),
    );
    final detailsController = TextEditingController(
      text: existingAmmunition?.details ?? '',
    );

    WeaponGroup? selectedGroup =
        existingAmmunition?.compatibleWeaponGroups.firstOrNull;

    final formKey = GlobalKey<FormState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = (screenWidth - 128).clamp(160.0, 512.0);

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              existingStack == null ? 'Add Ammunition' : 'Edit Ammunition',
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
                      FormInput(
                        controller: nameController,
                        label: 'Name',
                        isRequired: true,
                      ),
                      const SizedBox(height: 12),
                      FormInput(
                        controller: quantityController,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        isInteger: true,
                        minValue: 0,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Compatible Weapon Groups',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FormDropdown<WeaponGroup>(
                        label: 'Compatible Weapon Group',
                        value: selectedGroup,
                        items: WeaponGroup.rangedGroups,
                        itemLabel: _weaponGroupLabel,
                        onChanged: (group) {
                          setDialogState(() {
                            selectedGroup = group;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      FormInput(
                        controller: detailsController,
                        label: 'Ammunition Details',
                        maxLines: 2,
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

      return AmmunitionStack(
        id: existingStack?.id,
        ammunition: Ammunition(
          name: nameController.text.trim(),
          details: detailsController.text.trim(),
          compatibleWeaponGroups: selectedGroup == null ? [] : [selectedGroup!],
        ),
        quantity: int.parse(quantityController.text.trim()),
      );
    } finally {
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        nameController.dispose();
        quantityController.dispose();
        detailsController.dispose();
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
}
