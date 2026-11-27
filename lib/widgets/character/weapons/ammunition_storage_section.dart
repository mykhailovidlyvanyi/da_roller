//lib/widgets/character/weapons/ammunition_storage_section.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/ammunition/ammunition.dart';
import '../../../models/ammunition/ammunition_stack.dart';
import '../../../models/ammunition/ammunition_storage.dart';
import '../../../models/weapons/weapon_group.dart';

import '../common/form_dropdown.dart';
import '../common/form_input.dart';
import '../common/editable_value_cell.dart';
import '../common/header_cell.dart';
import '../common/editable_item_row.dart';

class AmmunitionStorageSection extends StatefulWidget {
  final AmmunitionStorage storage;
  final ValueChanged<AmmunitionStorage> onStorageChanged;
  final bool expandToFill;

  const AmmunitionStorageSection({
    super.key,
    required this.storage,
    required this.onStorageChanged,
    this.expandToFill = true,
  });

  @override
  State<AmmunitionStorageSection> createState() =>
      _AmmunitionStorageSectionState();
}

class _AmmunitionStorageSectionState extends State<AmmunitionStorageSection> {
  static const double _ammunitionRowHeight = 80;

  Future<void> _editAmmunition({int? index}) async {
    final existingStack = index == null ? null : widget.storage.stacks[index];
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

    if (result == true && mounted) {
      final ammunition = Ammunition(
        name: nameController.text.trim(),
        details: detailsController.text.trim(),
        compatibleWeaponGroups: selectedGroup == null ? [] : [selectedGroup!],
      );

      final stack = AmmunitionStack(
        id: existingStack?.id,
        ammunition: ammunition,
        quantity: int.parse(quantityController.text.trim()),
      );

      final updatedStacks = [...widget.storage.stacks];

      if (index == null) {
        updatedStacks.add(stack);
      } else {
        updatedStacks[index] = stack;
      }

      widget.onStorageChanged(AmmunitionStorage(stacks: updatedStacks));
    }

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      nameController.dispose();
      quantityController.dispose();
      detailsController.dispose();
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

  void _removeAmmunition(int index) {
    final updatedStacks = [...widget.storage.stacks]..removeAt(index);

    widget.onStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  String _compatibleGroupsLabel(Ammunition ammunition) {
    if (ammunition.compatibleWeaponGroups.isEmpty) {
      return 'Not specified';
    }

    return ammunition.compatibleWeaponGroups.map(_weaponGroupLabel).join(', ');
  }

  Widget _ammunitionRow(int index) {
    final stack = widget.storage.stacks[index];
    final ammunition = stack.ammunition;

    return EditableItemRow(
      cells: [
        EditableValueCell(
          value: ammunition.name,
          flex: 3,
          onTap: () => _editAmmunition(index: index),
        ),
        EditableValueCell(
          value: stack.quantity.toString(),
          flex: 1,
          onTap: () => _editAmmunition(index: index),
        ),
        EditableValueCell(
          value: _compatibleGroupsLabel(ammunition),
          flex: 3,
          onTap: () => _editAmmunition(index: index),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 28, height: 36),
          tooltip: 'Remove ammunition',
          onPressed: () => _removeAmmunition(index),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white38,
            size: 17,
          ),
        ),
      ],
      details: ammunition.details,
      emptyDetailsText: 'Add ammunition details...',
      onDetailsTap: () => _editAmmunition(index: index),
    );
  }

  Widget _addAmmunitionButton(bool hasAmmunition) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: hasAmmunition
          ? TextButton.icon(
              onPressed: () => _editAmmunition(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Ammunition'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            )
          : Center(
              child: TextButton.icon(
                onPressed: () => _editAmmunition(),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Ammunition'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.greenAccent,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAmmunition = widget.storage.stacks.isNotEmpty;
    final visibleRowCount = widget.storage.stacks.length > 3
        ? 3
        : widget.storage.stacks.length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383838)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasAmmunition) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  HeaderCell(text: 'AMMUNITION', flex: 3),
                  HeaderCell(text: 'QTY', flex: 1),
                  HeaderCell(text: 'COMPATIBLE GROUPS', flex: 3),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            SizedBox(
              height: _ammunitionRowHeight * visibleRowCount,
              child: ListView.builder(
                itemCount: widget.storage.stacks.length,
                itemExtent: _ammunitionRowHeight,
                itemBuilder: (context, index) => _ammunitionRow(index),
              ),
            ),
          ],
          if (widget.expandToFill)
            Expanded(child: _addAmmunitionButton(hasAmmunition))
          else
            _addAmmunitionButton(hasAmmunition),
        ],
      ),
    );
  }
}
