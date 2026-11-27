//lib/widgets/dice/stunts/dice_stunts.dart

import 'package:material_ui/material_ui.dart';

bool hasStunts(List<int?> results) {
  if (results.length < 3) return false;

  final dice = results.take(3).toList();

  if (dice.any((value) => value == null)) return false;

  final first = dice[0]!;
  final second = dice[1]!;
  final dragon = dice[2]!;

  return first == second || first == dragon || second == dragon;
}

class DiceStunts extends StatelessWidget {
  final List<int?> results;
  final bool isAttackRoll;
  final bool isRolling;

  const DiceStunts({
    super.key,
    required this.results,
    required this.isAttackRoll,
    required this.isRolling,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAttackRoll || isRolling || !hasStunts(results)) {
      return const SizedBox.shrink();
    }

    final dragon = results[2]!;

    return SizedBox(
      width: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Stunts',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amberAccent, fontSize: 8),
          ),
          const SizedBox(height: 2),
          Text(
            dragon.toString(),
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
