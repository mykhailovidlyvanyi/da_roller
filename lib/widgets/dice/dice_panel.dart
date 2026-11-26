//lib/widgets/dice/dice_panel.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice_set_skin.dart';
import 'dice_group.dart';
import 'dice_results.dart';
import 'dice_panel_actions.dart';

class DicePanel extends StatelessWidget {
  final GlobalKey<DiceGroupState> diceGroupKey;
  final List<int?> results;
  final bool isRolling;
  final DiceSetSkin selectedSkinSet;
  final ValueChanged<List<int?>> onResultsChanged;
  final ValueChanged<bool> onRollingChanged;
  final VoidCallback onOpenSkinSelection;
  final int diceCount;
  final int? modifier;
  final String modifierLabel;
  final VoidCallback onRollAll;

  const DicePanel({
    super.key,
    required this.diceGroupKey,
    required this.results,
    required this.isRolling,
    required this.selectedSkinSet,
    required this.onResultsChanged,
    required this.onRollingChanged,
    required this.onOpenSkinSelection,
    required this.diceCount,
    required this.modifier,
    required this.modifierLabel,
    required this.onRollAll,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF242424);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Container(
        decoration: const BoxDecoration(
          color: cardColor,
          border: Border(top: BorderSide(color: Color(0xFF383838))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: DiceGroup(
                key: diceGroupKey,
                diceCount: diceCount,
                skinSet: selectedSkinSet,
                onResultsChanged: onResultsChanged,
                onRollingChanged: onRollingChanged,
              ),
            ),
            Expanded(
              flex: 5,
              child: DiceResults(
                results: results,
                diceCount: diceCount,
                modifier: modifier,
                modifierLabel: modifierLabel,
              ),
            ),
            Expanded(
              flex: 1,
              child: DicePanelActions(
                isRolling: isRolling,
                onOpenSkinSelection: onOpenSkinSelection,
                onRollAll: onRollAll,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
