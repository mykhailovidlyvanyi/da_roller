// /lib/widgets/character/character_info_section.dart

import 'package:material_ui/material_ui.dart';

import 'character_field.dart';

class CharacterInfoSection extends StatefulWidget {
  const CharacterInfoSection({super.key});

  @override
  State<CharacterInfoSection> createState() => _CharacterInfoSectionState();
}

class _CharacterInfoSectionState extends State<CharacterInfoSection> {
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _raceController = TextEditingController();
  final _levelController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _raceController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CharacterField(
          label: 'CHARACTER NAME',
          controller: _nameController,
          hint: 'Enter character name',
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: CharacterField(
                label: 'CLASS',
                controller: _classController,
                hint: 'Class',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CharacterField(
                label: 'RACE',
                controller: _raceController,
                hint: 'Race',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: 110,
          child: CharacterField(
            label: 'LEVEL',
            controller: _levelController,
            hint: '1',
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
