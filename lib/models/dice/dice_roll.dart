//lib/models/dice/dice_roll.dart

enum DiceRollType { attribute, attack, damage, panel, single }

class DiceRoll {
  final DiceRollType type;
  final int diceCount;
  final int modifier;
  final String? modifierLabel;
  final int? targetDieIndex;

  const DiceRoll({
    required this.type,
    required this.diceCount,
    this.modifier = 0,
    this.modifierLabel,
    this.targetDieIndex,
  }) : assert(diceCount > 0),
       assert(
         type != DiceRollType.single ||
             (diceCount == 1 &&
                 targetDieIndex != null &&
                 targetDieIndex >= 0 &&
                 targetDieIndex < 3),
       );
}
