//lib/widgets/character/combat/combat_column.dart

import 'package:material_ui/material_ui.dart';

class CombatColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CombatColumn({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
