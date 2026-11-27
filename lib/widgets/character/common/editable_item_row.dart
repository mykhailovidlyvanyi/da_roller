//lib/widgets/character/common/editable_item_row.dart

import 'package:material_ui/material_ui.dart';

class EditableItemRow extends StatelessWidget {
  final List<Widget> cells;
  final String details;
  final String emptyDetailsText;
  final VoidCallback onDetailsTap;
  final double detailsHeight;

  const EditableItemRow({
    super.key,
    required this.cells,
    required this.details,
    required this.emptyDetailsText,
    required this.onDetailsTap,
    this.detailsHeight = 20,
  });

  @override
  Widget build(BuildContext context) {
    final hasDetails = details.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF383838))),
      ),
      child: Column(
        children: [
          Row(children: cells),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDetailsTap,
            child: Container(
              width: double.infinity,
              height: detailsHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF303030))),
              ),
              child: SingleChildScrollView(
                child: Text(
                  hasDetails ? details : emptyDetailsText,
                  style: TextStyle(
                    color: hasDetails ? Colors.white60 : Colors.white30,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
