//lib/widgets/dice/dice_panel.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice_set_skin.dart';
import 'dice_group.dart';

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
    const resultItemWidth = 56.0;

    final displayDiceCount = diceCount < 3 ? 3 : diceCount;

    final allDiceRolled =
        diceCount <= results.length &&
        results.take(diceCount).every((value) => value != null);

    final diceSum = allDiceRolled
        ? results.take(diceCount).fold<int>(0, (sum, value) => sum + value!)
        : null;

    final total = diceSum != null ? diceSum + (modifier ?? 0) : null;

    Widget resultItem(String label, int? value, {Color? color}) {
      return SizedBox(
        width: resultItemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 8),
            ),
            const SizedBox(height: 2),
            Text(
              value?.toString() ?? '-',
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    Widget totalItem() {
      return SizedBox(
        width: resultItemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Total',
              style: TextStyle(color: Colors.white54, fontSize: 8),
            ),
            const SizedBox(height: 2),
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amberAccent, width: 1.5),
              ),
              child: Text(
                total?.toString() ?? '-',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < displayDiceCount; i++)
                      resultItem(
                        i == 2 ? 'Dragon Die' : 'Die ${i + 1}',
                        i < diceCount && i < results.length ? results[i] : null,
                        color: i == 2 ? Colors.orangeAccent : null,
                      ),
                    resultItem('Dice Sum', diceSum, color: Colors.cyanAccent),
                    resultItem(
                      modifierLabel.isEmpty ? 'Modifier' : modifierLabel,
                      modifier,
                      color: Colors.greenAccent,
                    ),
                    totalItem(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
