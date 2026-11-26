//lib/widgets/character/placeholder_section.dart

import 'package:material_ui/material_ui.dart';

class PlaceholderSection extends StatelessWidget {
  final String text;

  const PlaceholderSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF383838)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white30, fontSize: 13),
      ),
    );
  }
}
