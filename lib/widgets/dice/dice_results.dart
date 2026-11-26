//lib/widgets/dice/dice_results.dart

import 'package:material_ui/material_ui.dart';

class DiceResults extends StatelessWidget {
  final List<int?> results;
  final int diceCount;
  final int? modifier;
  final String modifierLabel;

  const DiceResults({
    super.key,
    required this.results,
    required this.diceCount,
    required this.modifier,
    required this.modifierLabel,
  });

  @override
  Widget build(BuildContext context) {
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

    return SingleChildScrollView(
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
    );
  }
}
