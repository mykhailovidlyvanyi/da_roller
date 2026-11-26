//lib/widgets/character/character_sheet.dart

import 'package:material_ui/material_ui.dart';

import 'attributes_section.dart';
import 'character_header.dart';
import 'character_info_section.dart';
import 'combat_section.dart';
import 'melee_weapons_section.dart';
import 'section_title.dart';
import 'placeholder_section.dart';

class CharacterSheet extends StatefulWidget {
  final ValueChanged<int?> onRollDice;
  final void Function(int diceCount, int modifier, String modifierLabel)
  onRollCustomDice;

  const CharacterSheet({
    super.key,
    required this.onRollDice,
    required this.onRollCustomDice,
  });

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  int _dexterity = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: AttributesSection(
            onRollDice: widget.onRollDice,
            onDexterityChanged: (value) {
              setState(() {
                _dexterity = value;
              });
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 24, 20, 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CharacterHeader(),

                const SizedBox(height: 24),

                const CharacterInfoSection(),

                const SizedBox(height: 32),

                CombatSection(dexterity: _dexterity),

                const SizedBox(height: 20),

                MeleeWeaponsSection(onRollCustomDice: widget.onRollCustomDice),

                const SizedBox(height: 32),

                const SectionTitle(title: 'ABILITIES & TALENTS'),

                const SizedBox(height: 12),

                const PlaceholderSection(
                  text: 'Abilities and talents will appear here',
                ),

                const SizedBox(height: 24),

                const SectionTitle(title: 'EQUIPMENT'),

                const SizedBox(height: 12),

                const PlaceholderSection(text: 'Weapons, armor and equipment'),

                const SizedBox(height: 24),

                const SectionTitle(title: 'NOTES'),

                const SizedBox(height: 12),

                const PlaceholderSection(
                  text: 'Character notes and background',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
