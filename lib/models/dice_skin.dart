// lib/models/dice_skin.dart

import 'package:material_ui/material_ui.dart';

enum PipStyle { round }

class DiceSkin {
  final String id;
  final String name;

  final Color faceColor;
  final Color pipColor;
  final Color edgeColor;
  final Color shadowColor;

  final double cornerRadius;
  final PipStyle pipStyle;
  final String? oneFaceImage;

  const DiceSkin({
    required this.id,
    required this.name,
    required this.faceColor,
    required this.pipColor,
    required this.edgeColor,
    required this.shadowColor,
    this.cornerRadius = 12,
    this.pipStyle = PipStyle.round,
    this.oneFaceImage,
  });

  static const classic = DiceSkin(
    id: 'classic',
    name: 'Classic',
    faceColor: Color(0xFFF5F2EA),
    pipColor: Color(0xFF252525),
    edgeColor: Color(0xFFD0CCC3),
    shadowColor: Color(0x80000000),
  );

  static const dragon = DiceSkin(
    id: 'dragon',
    name: 'Dragon Die',
    faceColor: Color(0xFF9E1828),
    pipColor: Color(0xFFFFD700),
    edgeColor: Color(0xFF64101C),
    shadowColor: Color(0x80000000),
  );

  static const symbol = DiceSkin(
    id: 'symbol',
    name: 'Symbol Die',
    faceColor: Color(0xFF9E1828),
    pipColor: Color(0xFFFFD700),
    edgeColor: Color(0xFF64101C),
    shadowColor: Color(0x80000000),
    oneFaceImage: 'assets/images/symbol.png',
  );
}
