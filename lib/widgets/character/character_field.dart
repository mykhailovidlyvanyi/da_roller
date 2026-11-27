//lib/widgets/character/character_field.dart

import 'package:material_ui/material_ui.dart';

class CharacterField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool horizontal;

  const CharacterField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = label.isEmpty
        ? const SizedBox.shrink()
        : Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          );

    final fieldWidget = TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF242424),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

    if (horizontal) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 220) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (label.isNotEmpty) ...[
                  labelWidget,
                  const SizedBox(height: 8),
                ],
                fieldWidget,
              ],
            );
          }

          return Row(
            children: [
              SizedBox(width: 105, child: labelWidget),
              const SizedBox(width: 12),
              Expanded(child: fieldWidget),
            ],
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[labelWidget, const SizedBox(height: 8)],
        fieldWidget,
      ],
    );
  }
}
