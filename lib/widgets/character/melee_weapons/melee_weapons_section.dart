//lib/widgets/character/melee_weapons/melee_weapons_section.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/dice/melee_weapon.dart';

class MeleeWeaponsSection extends StatefulWidget {
  final void Function(
    int diceCount,
    int modifier,
    String modifierLabel,
    bool isAttackRoll,
  )
  onRollCustomDice;

  const MeleeWeaponsSection({super.key, required this.onRollCustomDice});

  @override
  State<MeleeWeaponsSection> createState() => _MeleeWeaponsSectionState();
}

class _MeleeWeaponsSectionState extends State<MeleeWeaponsSection> {
  final List<MeleeWeapon> _weapons = [];

  Future<void> _editWeapon({int? index}) async {
    final existingWeapon = index == null ? null : _weapons[index];

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
    final detailsController = TextEditingController(
      text: existingWeapon?.details ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = (screenWidth - 128).clamp(160.0, 512.0);
    final isWide = contentWidth >= 440;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          existingWeapon == null ? 'Add Melee Weapon' : 'Edit Melee Weapon',
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
                          child: _buildInput(
                            controller: nameController,
                            label: 'Name',
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInput(
                            controller: attackBonusController,
                            label: 'Attack Bonus',
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                            ),
                            required: true,
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
                        _buildInput(
                          controller: nameController,
                          label: 'Name',
                          required: true,
                        ),
                        const SizedBox(height: 8),
                        _buildInput(
                          controller: attackBonusController,
                          label: 'Attack Bonus',
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                          ),
                          required: true,
                        ),
                        const SizedBox(height: 8),
                        _buildDamageInputs(
                          damageDiceController,
                          damageModifierController,
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  _buildInput(
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
    );

    if (result == true && mounted) {
      final weapon = MeleeWeapon(
        name: nameController.text.trim(),
        attackBonus: int.parse(attackBonusController.text.trim()),
        damageDice: int.parse(damageDiceController.text.trim()),
        damageModifier: int.parse(damageModifierController.text.trim()),
        details: detailsController.text.trim(),
      );

      setState(() {
        if (index == null) {
          _weapons.add(weapon);
        } else {
          _weapons[index] = weapon;
        }
      });
    }

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      nameController.dispose();
      attackBonusController.dispose();
      damageDiceController.dispose();
      damageModifierController.dispose();
      detailsController.dispose();
    });
  }

  Widget _buildDamageInputs(
    TextEditingController diceController,
    TextEditingController modifierController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildInput(
            controller: diceController,
            label: 'Damage',
            keyboardType: TextInputType.number,
            required: true,
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
          child: _buildInput(
            controller: modifierController,
            label: 'Damage',
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            required: true,
          ),
        ),
      ],
    );
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

        if (keyboardType == TextInputType.text) {
          return null;
        }

        if (text.isEmpty) {
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

  void _removeWeapon(int index) {
    setState(() {
      _weapons.removeAt(index);
    });
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

  Widget _weaponRow(int index) {
    final weapon = _weapons[index];

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
                value: weapon.name,
                flex: 3,
                onTap: () => _editWeapon(index: index),
              ),
              _valueCell(
                value: weapon.attackBonus >= 0
                    ? '+${weapon.attackBonus}'
                    : weapon.attackBonus.toString(),
                flex: 1,
                onTap: () => _editWeapon(index: index),
              ),
              _valueCell(
                value:
                    '${weapon.damageDice}d6'
                    '${weapon.damageModifier == 0
                        ? ''
                        : weapon.damageModifier > 0
                        ? ' + ${weapon.damageModifier}'
                        : ' - ${weapon.damageModifier.abs()}'}',
                flex: 2,
                onTap: () => _editWeapon(index: index),
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
                        widget.onRollCustomDice(
                          3,
                          weapon.attackBonus,
                          'Attack Bonus',
                          true,
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
                        widget.onRollCustomDice(
                          weapon.damageDice,
                          weapon.damageModifier,
                          'Damage Modifier',
                          false,
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
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 36,
                ),
                tooltip: 'Remove weapon',
                onPressed: () => _removeWeapon(index),
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
            onTap: () => _editWeapon(index: index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF303030))),
              ),
              child: Text(
                weapon.details.isEmpty
                    ? 'Add weapon details...'
                    : weapon.details,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: weapon.details.isEmpty
                      ? Colors.white30
                      : Colors.white60,
                  fontSize: 11,
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
                _headerCell('MELEE WEAPONS', flex: 3),
                _headerCell('ATTACK BONUS', flex: 1),
                _headerCell('DAMAGE', flex: 2),
                const SizedBox(width: 116),
              ],
            ),
          ),
          if (_weapons.isEmpty)
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
            ...List.generate(_weapons.length, _weaponRow),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF383838))),
            ),
            child: TextButton.icon(
              onPressed: () => _editWeapon(),
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
