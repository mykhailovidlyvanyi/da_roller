//lib/models/dice_set_skin.dart

import 'dice_skin.dart';

class DiceSetSkin {
  final String id;
  final String name;
  final List<DiceSkin> diceSkins;

  const DiceSetSkin({
    required this.id,
    required this.name,
    required this.diceSkins,
  });

  static const classic = DiceSetSkin(
    id: 'classic',
    name: 'Classic',
    diceSkins: [DiceSkin.classic, DiceSkin.classic, DiceSkin.classic],
  );

  static const dragon = DiceSetSkin(
    id: 'dragon',
    name: 'Dragon Die',
    diceSkins: [DiceSkin.classic, DiceSkin.classic, DiceSkin.dragon],
  );

  static const symbol = DiceSetSkin(
    id: 'symbol',
    name: 'Symbol Die',
    diceSkins: [DiceSkin.classic, DiceSkin.classic, DiceSkin.symbol],
  );
}
