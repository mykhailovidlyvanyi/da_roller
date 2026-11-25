// lib/services/dice_service.dart

import 'dart:math';

class DiceService {
  final Random _random;

  DiceService({Random? random}) : _random = random ?? Random();

  int roll() {
    return _random.nextInt(6) + 1;
  }
}
