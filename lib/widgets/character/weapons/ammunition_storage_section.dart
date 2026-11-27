//lib/widgets/character/weapons/ammunition_storage_section.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/ammunition/ammunition.dart';
import '../../../models/ammunition/ammunition_stack.dart';
import '../../../models/ammunition/ammunition_storage.dart';
import '../../../models/weapons/weapon_group.dart';

class AmmunitionStorageSection extends StatefulWidget {
  final AmmunitionStorage storage;
  final ValueChanged<AmmunitionStorage> onStorageChanged;

  const AmmunitionStorageSection({
    super.key,
    required this.storage,
    required this.onStorageChanged,
  });

  @override
  State<AmmunitionStorageSection> createState() =>
      _AmmunitionStorageSectionState();
}

class _AmmunitionStorageSectionState extends State<AmmunitionStorageSection> {
  static const double _ammunitionRowHeight = 80;
  static const double _detailsHeight = 20;

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

    final selectedGroups = <WeaponGroup>{
      ...?existingAmmunition?.compatibleWeaponGroups,
    };

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
                    _buildInput(
                      controller: nameController,
                      label: 'Name',
                      required: true,
                    ),
                    const SizedBox(height: 12),
                    _buildInput(
                      controller: quantityController,
                      label: 'Quantity',
                      keyboardType: TextInputType.number,
                      required: true,
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
                    ...WeaponGroup.rangedGroups.map(
                      (group) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.greenAccent,
                        checkColor: Colors.black,
                        title: Text(
                          _weaponGroupLabel(group),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        value: selectedGroups.contains(group),
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selectedGroups.add(group);
                            } else {
                              selectedGroups.remove(group);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInput(
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
        compatibleWeaponGroups: selectedGroups.toList(),
      );

      final stack = AmmunitionStack(
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

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
    int? minValue,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (required && text.isEmpty) {
          return 'This field is required';
        }

        if (keyboardType == TextInputType.text || text.isEmpty) {
          return null;
        }

        final number = int.tryParse(text);

        if (number == null) {
          return 'Enter a valid number';
        }

        if (minValue != null && number < minValue) {
          return 'Minimum value is $minValue';
        }

        return null;
      },
    );
  }

  void _removeAmmunition(int index) {
    final updatedStacks = [...widget.storage.stacks]..removeAt(index);

    widget.onStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  Widget _headerCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _valueCell({
    required String value,
    required int flex,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _valueCell(
                value: ammunition.name,
                flex: 3,
                onTap: () => _editAmmunition(index: index),
              ),
              _valueCell(
                value: stack.quantity.toString(),
                flex: 1,
                onTap: () => _editAmmunition(index: index),
              ),
              _valueCell(
                value: _compatibleGroupsLabel(ammunition),
                flex: 3,
                onTap: () => _editAmmunition(index: index),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 36,
                ),
                tooltip: 'Remove ammunition',
                onPressed: () => _removeAmmunition(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white38,
                  size: 17,
                ),
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _editAmmunition(index: index),
            child: Container(
              width: double.infinity,
              height: _detailsHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF303030))),
              ),
              child: SingleChildScrollView(
                child: Text(
                  ammunition.details.isEmpty
                      ? 'Add ammunition details...'
                      : ammunition.details,
                  style: TextStyle(
                    color: ammunition.details.isEmpty
                        ? Colors.white30
                        : Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  _headerCell('AMMUNITION', flex: 3),
                  _headerCell('QTY', flex: 1),
                  _headerCell('COMPATIBLE GROUPS', flex: 3),
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
          Expanded(
            child: Container(
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
            ),
          ),
        ],
      ),
    );
  }
}
