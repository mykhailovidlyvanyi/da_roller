//lib/widgets/character/weapons/ammunition_storage_section.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/ammunition/ammunition.dart';
import 'package:da_roller/models/ammunition/ammunition_stack.dart';
import 'package:da_roller/models/ammunition/ammunition_storage.dart';

import 'package:da_roller/models/weapons/weapon_group.dart';

import 'package:da_roller/widgets/character/common/ammunition_editor.dart';
import 'package:da_roller/widgets/character/common/editable_value_cell.dart';
import 'package:da_roller/widgets/character/common/header_cell.dart';
import 'package:da_roller/widgets/character/common/editable_item_row.dart';

class AmmunitionStorageSection extends StatefulWidget {
  final AmmunitionStorage storage;
  final ValueChanged<AmmunitionStorage> onStorageChanged;
  final bool expandToFill;
  final String? equippedStackId;
  final ValueChanged<String?> onEquipStack;

  const AmmunitionStorageSection({
    super.key,
    required this.storage,
    required this.onStorageChanged,
    this.expandToFill = true,
    required this.equippedStackId,
    required this.onEquipStack,
  });

  @override
  State<AmmunitionStorageSection> createState() =>
      _AmmunitionStorageSectionState();
}

class _AmmunitionStorageSectionState extends State<AmmunitionStorageSection> {
  static const double _ammunitionRowHeight = 80;

  List<AmmunitionStack> get _displayedStacks {
    final equippedStackId = widget.equippedStackId;

    return [
      ...widget.storage.stacks.where((stack) => stack.id == equippedStackId),
      ...widget.storage.stacks.where((stack) => stack.id != equippedStackId),
    ];
  }

  Future<void> _editAmmunition({int? index}) async {
    final existingStack = index == null ? null : widget.storage.stacks[index];

    final updatedStack = await AmmunitionEditor.show(
      context,
      existingStack: existingStack,
    );

    if (updatedStack == null || !mounted) return;

    final updatedStacks = [...widget.storage.stacks];

    if (index == null) {
      updatedStacks.add(updatedStack);
    } else {
      updatedStacks[index] = updatedStack;
    }

    widget.onStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  void _removeAmmunition(int index) {
    final updatedStacks = [...widget.storage.stacks]..removeAt(index);

    widget.onStorageChanged(AmmunitionStorage(stacks: updatedStacks));
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

  String _compatibleGroupsLabel(Ammunition ammunition) {
    if (ammunition.compatibleWeaponGroups.isEmpty) {
      return 'Not specified';
    }

    return ammunition.compatibleWeaponGroups.map(_weaponGroupLabel).join(', ');
  }

  Widget _ammunitionRow(AmmunitionStack stack) {
    final ammunition = stack.ammunition;
    final originalIndex = widget.storage.stacks.indexWhere(
      (item) => item.id == stack.id,
    );

    return EditableItemRow(
      cells: [
        Expanded(
          flex: 2,
          child: Center(child: Radio<String>(value: stack.id)),
        ),
        EditableValueCell(
          value: ammunition.name,
          flex: 3,
          onTap: () => _editAmmunition(index: originalIndex),
        ),
        EditableValueCell(
          value: stack.quantity.toString(),
          flex: 1,
          onTap: () => _editAmmunition(index: originalIndex),
        ),
        EditableValueCell(
          value: _compatibleGroupsLabel(ammunition),
          flex: 3,
          onTap: () => _editAmmunition(index: originalIndex),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 28, height: 36),
          tooltip: 'Remove ammunition',
          onPressed: () => _removeAmmunition(originalIndex),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white38,
            size: 17,
          ),
        ),
      ],
      details: ammunition.details,
      emptyDetailsText: 'Add ammunition details...',
      onDetailsTap: () => _editAmmunition(index: originalIndex),
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
    final displayedStacks = _displayedStacks;
    final hasAmmunition = displayedStacks.isNotEmpty;
    final visibleRowCount = displayedStacks.length > 3
        ? 3
        : displayedStacks.length;

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
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: TextButton(
                        onPressed: widget.equippedStackId == null
                            ? null
                            : () => widget.onEquipStack(null),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.greenAccent,
                          disabledForegroundColor: Colors.white24,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Unequip',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  HeaderCell(text: 'AMMUNITION', flex: 3),
                  HeaderCell(text: 'QTY', flex: 1),
                  HeaderCell(text: 'COMPATIBLE GROUPS', flex: 3),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            RadioGroup<String>(
              groupValue: widget.equippedStackId,
              onChanged: widget.onEquipStack,
              child: SizedBox(
                height: _ammunitionRowHeight * visibleRowCount,
                child: ListView.builder(
                  itemCount: displayedStacks.length,
                  itemExtent: _ammunitionRowHeight,
                  itemBuilder: (context, index) =>
                      _ammunitionRow(displayedStacks[index]),
                ),
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
