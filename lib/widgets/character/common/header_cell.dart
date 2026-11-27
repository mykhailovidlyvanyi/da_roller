//lib/widgets/character/common/header_cell.dart

import 'package:material_ui/material_ui.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const HeaderCell({super.key, required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
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
}
