//lib/widgets/dice/dice_panel_actions.dart

import 'package:material_ui/material_ui.dart';

class DicePanelActions extends StatelessWidget {
  final bool isRolling;
  final VoidCallback onOpenSkinSelection;
  final VoidCallback onRollAll;

  const DicePanelActions({
    super.key,
    required this.isRolling,
    required this.onOpenSkinSelection,
    required this.onRollAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: isRolling ? null : onOpenSkinSelection,
          icon: const Icon(
            Icons.palette_outlined,
            color: Colors.white70,
            size: 20,
          ),
          tooltip: 'Dice skins',
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: isRolling ? null : onRollAll,
          icon: const Icon(
            Icons.casino_outlined,
            color: Colors.white,
            size: 20,
          ),
          tooltip: 'Roll all',
        ),
      ],
    );
  }
}
