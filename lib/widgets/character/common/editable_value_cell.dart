//lib/widgets/character/common/editable_value_cell.dart

import 'package:material_ui/material_ui.dart';

class EditableValueCell extends StatelessWidget {
  final String value;
  final int flex;
  final VoidCallback onTap;

  const EditableValueCell({
    super.key,
    required this.value,
    required this.flex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}
