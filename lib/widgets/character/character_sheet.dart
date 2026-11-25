// /lib/widgets/character/character_sheet.dart

import 'package:material_ui/material_ui.dart';

import 'attributes_section.dart';
import 'character_header.dart';
import 'character_info_section.dart';
import 'combat_section.dart';
import 'section_title.dart';
import 'placeholder_section.dart';

class CharacterSheet extends StatelessWidget {
  final ValueChanged<int?> onRollDice;

  const CharacterSheet({super.key, required this.onRollDice});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left column: Attributes (20%)
        Expanded(flex: 1, child: AttributesSection(onRollDice: onRollDice)),

        const SizedBox(width: 16),

        // Right column: Everything else (80%)
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

                const CombatSection(),

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
