//lib/widgets/dice/panel/dice_panel.dart

import 'package:material_ui/material_ui.dart';

import '../../../models/dice/dice_set_skin.dart';
import 'dice_group.dart';
import '../results/dice_results.dart';
import 'dice_panel_actions.dart';
import '../stunts/dice_stunts.dart';

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
  final bool isAttackRoll;
  final ValueChanged<int> onSingleRollRequested;

  final int? selectedSingleDieIndex;

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
    required this.isAttackRoll,
    required this.onSingleRollRequested,
    required this.selectedSingleDieIndex,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF242424);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        final spacing = (constraints.maxWidth * 0.02)
            .clamp(8.0, 20.0)
            .toDouble();

        final diceGroup = DiceGroup(
          key: diceGroupKey,
          diceCount: diceCount,
          skinSet: selectedSkinSet,
          onResultsChanged: onResultsChanged,
          onRollingChanged: onRollingChanged,
          onSingleRollRequested: onSingleRollRequested,
        );

        final diceResults = DiceResults(
          results: results,
          diceCount: diceCount,
          modifier: modifier,
          modifierLabel: modifierLabel,
          selectedSingleDieIndex: selectedSingleDieIndex,
        );

        final stunts = SizedBox(
          width: 72,
          child: DiceStunts(
            results: results,
            isAttackRoll: isAttackRoll,
            isRolling: isRolling,
          ),
        );

        final actions = DicePanelActions(
          isRolling: isRolling,
          onOpenSkinSelection: onOpenSkinSelection,
          onRollAll: onRollAll,
        );

        return Container(
          decoration: const BoxDecoration(
            color: cardColor,
            border: Border(top: BorderSide(color: Color(0xFF383838))),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isCompact ? 8 : 4,
          ),
          child: isCompact
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    diceGroup,
                    SizedBox(height: spacing),
                    SizedBox(height: 40, child: diceResults),
                    SizedBox(height: spacing),
                    SizedBox(height: 28, child: stunts),
                    SizedBox(height: spacing),
                    actions,
                  ],
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: diceGroup),
                      SizedBox(width: spacing),
                      Expanded(flex: 5, child: diceResults),
                      SizedBox(width: spacing),
                      stunts,
                      SizedBox(width: spacing),
                      SizedBox(width: 88, child: actions),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
