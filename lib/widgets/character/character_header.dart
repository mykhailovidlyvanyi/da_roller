// /lib/widgets/character/character_header.dart

import 'package:material_ui/material_ui.dart';

class CharacterHeader extends StatelessWidget {
  const CharacterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'CHARACTER SHEET',
      style: TextStyle(
        color: Colors.white54,
        fontSize: 12,
        letterSpacing: 3,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
