//lib/widgets/character/character_info/character_info_section.dart

import 'package:material_ui/material_ui.dart';

import 'character_avatar.dart';
import 'character_field.dart';
import 'expandable_character_field.dart';

class CharacterInfoSection extends StatefulWidget {
  const CharacterInfoSection({super.key});

  @override
  State<CharacterInfoSection> createState() => _CharacterInfoSectionState();
}

class _CharacterInfoSectionState extends State<CharacterInfoSection> {
  final _nameController = TextEditingController();
  final _backgroundController = TextEditingController();
  final _classController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _appearanceController = TextEditingController();
  final _experienceController = TextEditingController();
  final _levelController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _backgroundController.dispose();
    _classController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _appearanceController.dispose();
    _experienceController.dispose();
    _levelController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name, Background and Avatar

        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CharacterField(
                    label: 'NAME',
                    controller: _nameController,
                    hint: 'Enter character name',
                    horizontal: true,
                  ),

                  const SizedBox(height: 12),

                  CharacterField(
                    label: 'BACKGROUND',
                    controller: _backgroundController,
                    hint: 'Character background',
                    horizontal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            const CharacterAvatar(),
          ],
        ),

        const SizedBox(height: 12),

        // Class, Experience and Level
        Row(
          children: [
            Expanded(
              child: CharacterField(
                label: 'CLASS',
                controller: _classController,
                hint: 'Class',
                horizontal: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CharacterField(
                label: 'EXPERIENCE',
                controller: _experienceController,
                hint: 'XP',
                keyboardType: TextInputType.number,
                horizontal: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CharacterField(
                label: 'LEVEL',
                controller: _levelController,
                hint: '1',
                keyboardType: TextInputType.number,
                horizontal: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Age, Gender, Weight and Height
        Row(
          children: [
            Expanded(
              child: CharacterField(
                label: 'AGE',
                controller: _ageController,
                hint: 'Age',
                keyboardType: TextInputType.number,
                horizontal: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CharacterField(
                label: 'GENDER',
                controller: _genderController,
                hint: 'Gender',
                horizontal: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CharacterField(
                label: 'WEIGHT',
                controller: _weightController,
                hint: 'Weight',
                keyboardType: TextInputType.number,
                horizontal: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CharacterField(
                label: 'HEIGHT',
                controller: _heightController,
                hint: 'Height',
                keyboardType: TextInputType.number,
                horizontal: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Appearance
        ExpandableCharacterField(
          label: 'APPEARANCE',
          controller: _appearanceController,
          hint: 'Describe character appearance',
        ),
      ],
    );
  }
}
