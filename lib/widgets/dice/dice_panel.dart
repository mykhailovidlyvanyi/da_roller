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
  final int? attributeValue;

  const DicePanel({
    super.key,
    required this.diceGroupKey,
    required this.results,
    required this.isRolling,
    required this.selectedSkinSet,
    required this.onResultsChanged,
    required this.onRollingChanged,
    required this.onOpenSkinSelection,
    required this.attributeValue,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF242424);

    final die1 = results.isNotEmpty ? results[0] : null;
    final die2 = results.length > 1 ? results[1] : null;
    final dragonDie = results.length > 2 ? results[2] : null;

    final diceSum = die1 != null && die2 != null && dragonDie != null
        ? die1 + die2 + dragonDie
        : null;

    final total = diceSum != null && attributeValue != null
        ? diceSum + attributeValue!
        : null;

    Widget resultItem(String label, int? value, {Color? color}) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
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
            // Dice
            Expanded(
              flex: 3,
              child: DiceGroup(
                key: diceGroupKey,
                diceCount: 3,
                skinSet: selectedSkinSet,
                onResultsChanged: onResultsChanged,
                onRollingChanged: onRollingChanged,
              ),
            ),

            // Results
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  resultItem('Die 1', die1),
                  resultItem('Die 2', die2),
                  resultItem(
                    'Dragon Die',
                    dragonDie,
                    color: Colors.orangeAccent,
                  ),
                  resultItem('Dice Sum', diceSum, color: Colors.cyanAccent),
                  resultItem(
                    'Attribute',
                    attributeValue,
                    color: Colors.greenAccent,
                  ),
                  Column(
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
                          border: Border.all(
                            color: Colors.amberAccent,
                            width: 1.5,
                          ),
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
                ],
              ),
            ),

            // Buttons
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
                    onPressed: isRolling
                        ? null
                        : () => diceGroupKey.currentState?.rollAll(),
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
