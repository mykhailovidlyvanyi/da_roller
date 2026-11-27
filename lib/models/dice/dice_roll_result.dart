//lib/models/dice/dice_roll_result.dart

import 'dice_roll.dart';

class DiceRollResult {
  final DiceRoll roll;
  final List<int> diceResults;

  DiceRollResult({required this.roll, required List<int> diceResults})
    : diceResults = List.unmodifiable(diceResults) {
    if (diceResults.length != roll.diceCount) {
      throw ArgumentError(
        'Expected ${roll.diceCount} dice results, '
        'but received ${diceResults.length}.',
      );
    }

    if (diceResults.any((value) => value < 1 || value > 6)) {
      throw ArgumentError('Each die result must be between 1 and 6.');
    }
  }

  int get diceSum => diceResults.fold(0, (sum, value) => sum + value);

  int get total => diceSum + roll.modifier;
}
