//lib/widgets/character/common/table_header.dart

import 'package:material_ui/material_ui.dart';

import 'header_cell.dart';

class TableHeader extends StatelessWidget {
  final String title;
  final bool showUnequip;
  final VoidCallback? onUnequip;

  const TableHeader({
    super.key,
    required this.title,
    this.showUnequip = false,
    this.onUnequip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: showUnequip
                  ? TextButton(
                      onPressed: onUnequip,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: Colors.white54,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      child: const Text('Unequip'),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          HeaderCell(text: 'ATTACK BONUS', flex: 1),
          HeaderCell(text: 'DAMAGE', flex: 2),
          const Expanded(flex: 3, child: SizedBox()),
        ],
      ),
    );
  }
}
