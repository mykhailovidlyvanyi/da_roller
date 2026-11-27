//lib/services/dice_roll_service.dart

import '../models/dice/dice_roll.dart';
import '../models/dice/dice_roll_result.dart';

class DiceRollService {
  DiceRollResult createResult({
    required DiceRoll roll,
    required List<int> diceResults,
  }) {
    return DiceRollResult(roll: roll, diceResults: diceResults);
  }
}
