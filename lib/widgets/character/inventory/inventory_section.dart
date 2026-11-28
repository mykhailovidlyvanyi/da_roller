// lib/widgets/character/inventory/inventory_section.dart

import 'package:material_ui/material_ui.dart';

import 'package:da_roller/models/character/character_inventory.dart';
import 'package:da_roller/models/character/character_equipment.dart';
import 'package:da_roller/models/character/miscellaneous_item.dart';
import 'package:da_roller/models/ammunition/ammunition_stack.dart';
import 'package:da_roller/models/ammunition/ammunition_storage.dart';
import 'package:da_roller/models/weapons/melee_weapon.dart';
import 'package:da_roller/models/weapons/ranged_weapon.dart';

import 'package:da_roller/widgets/character/common/melee_weapon_editor.dart';
import 'package:da_roller/widgets/character/common/range_weapon_editor.dart';
import 'package:da_roller/widgets/character/common/ammunition_editor.dart';
import 'package:da_roller/widgets/character/common/miscellaneous_item_editor.dart';

class InventorySection extends StatelessWidget {
  final CharacterInventory inventory;
  final CharacterEquipment equipment;

  final ValueChanged<MeleeWeapon> onAddMeleeWeapon;
  final ValueChanged<RangedWeapon> onAddRangedWeapon;

  final ValueChanged<MeleeWeapon> onUpdateMeleeWeapon;
  final ValueChanged<RangedWeapon> onUpdateRangedWeapon;
  final ValueChanged<String> onRemoveMeleeWeapon;
  final ValueChanged<String> onRemoveRangedWeapon;
  final ValueChanged<AmmunitionStorage> onAmmunitionStorageChanged;

  final ValueChanged<MiscellaneousItem> onAddMiscellaneousItem;
  final ValueChanged<MiscellaneousItem> onUpdateMiscellaneousItem;
  final ValueChanged<String> onRemoveMiscellaneousItem;

  final ValueChanged<String?> onEquipMeleeWeapon;
  final ValueChanged<String?> onEquipRangedWeapon;
  final ValueChanged<String?> onEquipAmmunition;

  const InventorySection({
    super.key,
    required this.inventory,
    required this.equipment,
    required this.onAddMeleeWeapon,
    required this.onAddRangedWeapon,
    required this.onUpdateMeleeWeapon,
    required this.onUpdateRangedWeapon,
    required this.onRemoveMeleeWeapon,
    required this.onRemoveRangedWeapon,
    required this.onAmmunitionStorageChanged,
    required this.onAddMiscellaneousItem,
    required this.onUpdateMiscellaneousItem,
    required this.onRemoveMiscellaneousItem,
    required this.onEquipMeleeWeapon,
    required this.onEquipRangedWeapon,
    required this.onEquipAmmunition,
  });

  Future<void> _addMeleeWeapon(BuildContext context) async {
    final weapon = await MeleeWeaponEditor.show(context);

    if (weapon == null || !context.mounted) return;

    onAddMeleeWeapon(weapon);
  }

  Future<void> _addRangedWeapon(BuildContext context) async {
    final weapon = await RangedWeaponEditor.show(context);

    if (weapon == null || !context.mounted) return;

    onAddRangedWeapon(weapon);
  }

  Future<void> _addAmmunition(BuildContext context) async {
    final stack = await AmmunitionEditor.show(context);

    if (stack == null || !context.mounted) return;

    final updatedStacks = [...inventory.ammunitionStorage.stacks, stack];

    onAmmunitionStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  Future<void> _addMiscellaneousItem(BuildContext context) async {
    final item = await MiscellaneousItemEditor.show(context);

    if (item == null || !context.mounted) return;

    onAddMiscellaneousItem(item);
  }

  Future<void> _editMeleeWeapon(
      BuildContext context,
      MeleeWeapon weapon,
      ) async {
    final updatedWeapon = await MeleeWeaponEditor.show(
      context,
      existingWeapon: weapon,
    );

    if (updatedWeapon == null || !context.mounted) return;

    onUpdateMeleeWeapon(updatedWeapon);
  }

  Future<void> _editRangedWeapon(
      BuildContext context,
      RangedWeapon weapon,
      ) async {
    final updatedWeapon = await RangedWeaponEditor.show(
      context,
      existingWeapon: weapon,
    );

    if (updatedWeapon == null || !context.mounted) return;

    onUpdateRangedWeapon(updatedWeapon);
  }

  Future<void> _editAmmunition(
      BuildContext context,
      AmmunitionStack stack,
      ) async {
    final updatedStack = await AmmunitionEditor.show(
      context,
      existingStack: stack,
    );

    if (updatedStack == null || !context.mounted) return;

    final updatedStacks = inventory.ammunitionStorage.stacks.map((item) {
      return item.id == stack.id ? updatedStack : item;
    }).toList();

    onAmmunitionStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  Future<void> _editMiscellaneousItem(
      BuildContext context,
      MiscellaneousItem item,
      ) async {
    final updatedItem = await MiscellaneousItemEditor.show(
      context,
      existingItem: item,
    );

    if (updatedItem == null || !context.mounted) return;

    onUpdateMiscellaneousItem(updatedItem);
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final selectedType = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildItemTypeOption(dialogContext, 'Melee Weapon', 'melee'),
            _buildItemTypeOption(dialogContext, 'Ranged Weapon', 'ranged'),
            _buildItemTypeOption(dialogContext, 'Ammunition', 'ammunition'),
            _buildItemTypeOption(
              dialogContext,
              'Miscellaneous',
              'miscellaneous',
            ),
          ],
        ),
      ),
    );

    if (selectedType == null || !context.mounted) return;

    switch (selectedType) {
      case 'melee':
        await _addMeleeWeapon(context);
      case 'ranged':
        await _addRangedWeapon(context);
      case 'ammunition':
        await _addAmmunition(context);
      case 'miscellaneous':
        await _addMiscellaneousItem(context);
    }
  }

  Widget _buildItemTypeOption(
      BuildContext context,
      String title,
      String value,
      ) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(context, value),
    );
  }

  Widget _buildAddItemButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: TextButton.icon(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Item'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.greenAccent,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, VoidCallback? onTap}) {
    final content = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: onTap != null ? Colors.greenAccent : Colors.white,
        fontSize: 12,
      ),
      overflow: TextOverflow.ellipsis,
    );

    return Expanded(
      flex: flex,
      child: onTap == null
          ? content
          : InkWell(
        onTap: onTap,
        child: Center(child: content),
      ),
    );
  }

  Widget _buildEquipButton({
    required bool isEquipped,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      flex: 2,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: isEquipped
              ? Colors.orangeAccent
              : Colors.greenAccent,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          minimumSize: const Size(0, 36),
        ),
        child: Text(
          isEquipped ? 'Unequip' : 'Equip',
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback onPressed) {
    return Expanded(
      flex: 1,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        tooltip: 'Delete item',
        onPressed: onPressed,
        icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 18),
      ),
    );
  }

  Widget _buildRow({
    required String name,
    required String type,
    required int quantity,
    required String cost,
    required bool isEquipped,
    required VoidCallback onEquip,
    required VoidCallback onDelete,
    VoidCallback? onNameTap,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: Row(
        children: [
          _buildEquipButton(isEquipped: isEquipped, onPressed: onEquip),
          _buildCell(name, flex: 3, onTap: onNameTap),
          _buildCell(type, flex: 2),
          _buildCell(quantity.toString()),
          _buildCell(cost),
          _buildDeleteButton(onDelete),
        ],
      ),
    );
  }

  Widget _buildMiscellaneousRow(BuildContext context, MiscellaneousItem item) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          _buildCell(
            item.name,
            flex: 3,
            onTap: () => _editMiscellaneousItem(context, item),
          ),
          _buildCell('Miscellaneous', flex: 2),
          _buildCell(item.quantity.toString()),
          _buildCell(item.cost?.toString() ?? '-'),
          _buildDeleteButton(() => onRemoveMiscellaneousItem(item.id)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _buildHeaderCell('Equipped', flex: 2),
          _buildHeaderCell('Name', flex: 3),
          _buildHeaderCell('Type', flex: 2),
          _buildHeaderCell('Qty'),
          _buildHeaderCell('Cost'),
          _buildHeaderCell('Actions'),
        ],
      ),
    );
  }

  void _deleteAmmunitionStack(AmmunitionStack stack) {
    final updatedStacks = inventory.ammunitionStorage.stacks
        .where((item) => item.id != stack.id)
        .toList();

    onAmmunitionStorageChanged(AmmunitionStorage(stacks: updatedStacks));
  }

  @override
  Widget build(BuildContext context) {
    final meleeWeapons = [
      ...inventory.meleeWeapons.where(
            (weapon) => weapon.id == equipment.equippedMeleeWeaponId,
      ),
      ...inventory.meleeWeapons.where(
            (weapon) => weapon.id != equipment.equippedMeleeWeaponId,
      ),
    ];

    final rangedWeapons = [
      ...inventory.rangedWeapons.where(
            (weapon) => weapon.id == equipment.equippedRangedWeaponId,
      ),
      ...inventory.rangedWeapons.where(
            (weapon) => weapon.id != equipment.equippedRangedWeaponId,
      ),
    ];

    final ammunitionStacks = [
      ...inventory.ammunitionStorage.stacks.where(
            (stack) => stack.id == equipment.equippedAmmunitionId,
      ),
      ...inventory.ammunitionStorage.stacks.where(
            (stack) => stack.id != equipment.equippedAmmunitionId,
      ),
    ];

    final miscellaneousItems = inventory.miscellaneousItems;

    final totalItems =
        meleeWeapons.length +
            rangedWeapons.length +
            ammunitionStacks.length +
            miscellaneousItems.length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF383838)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(),
          if (totalItems == 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No items in inventory',
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            )
          else ...[
            ...meleeWeapons.map(
                  (weapon) => _buildRow(
                name: weapon.name,
                type: 'Melee Weapon',
                quantity: 1,
                cost: weapon.cost?.toString() ?? '-',
                isEquipped: weapon.id == equipment.equippedMeleeWeaponId,
                onEquip: () {
                  onEquipMeleeWeapon(
                    weapon.id == equipment.equippedMeleeWeaponId
                        ? null
                        : weapon.id,
                  );
                },
                onDelete: () => onRemoveMeleeWeapon(weapon.id),
                onNameTap: () => _editMeleeWeapon(context, weapon),
              ),
            ),
            ...rangedWeapons.map(
                  (weapon) => _buildRow(
                name: weapon.name,
                type: 'Ranged Weapon',
                quantity: 1,
                cost: weapon.cost?.toString() ?? '-',
                isEquipped: weapon.id == equipment.equippedRangedWeaponId,
                onEquip: () {
                  onEquipRangedWeapon(
                    weapon.id == equipment.equippedRangedWeaponId
                        ? null
                        : weapon.id,
                  );
                },
                onDelete: () => onRemoveRangedWeapon(weapon.id),
                onNameTap: () => _editRangedWeapon(context, weapon),
              ),
            ),
            ...ammunitionStacks.map(
                  (stack) => _buildRow(
                name: stack.ammunition.name,
                type: 'Ammunition',
                quantity: stack.quantity,
                cost: '-',
                isEquipped: stack.id == equipment.equippedAmmunitionId,
                onEquip: () {
                  onEquipAmmunition(
                    stack.id == equipment.equippedAmmunitionId
                        ? null
                        : stack.id,
                  );
                },
                onDelete: () => _deleteAmmunitionStack(stack),
                onNameTap: () => _editAmmunition(context, stack),
              ),
            ),
            ...miscellaneousItems.map(
                  (item) => _buildMiscellaneousRow(context, item),
            ),
          ],
          _buildAddItemButton(context),
        ],
      ),
    );
  }
}
