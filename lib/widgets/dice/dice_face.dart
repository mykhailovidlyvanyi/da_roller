// lib/widgets/dice/dice_face.dart

import 'package:material_ui/material_ui.dart';

import '../../models/dice_skin.dart';

class DiceFace extends StatelessWidget {
  final int value;
  final DiceSkin skin;
  final double size;

  const DiceFace({
    super.key,
    required this.value,
    required this.skin,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: skin.faceColor,
        borderRadius: BorderRadius.circular(skin.cornerRadius),
        border: Border.all(color: skin.edgeColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: skin.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _PipPainter(value: value, color: skin.pipColor),
      ),
    );
  }
}

class _PipPainter extends CustomPainter {
  final int value;
  final Color color;

  const _PipPainter({required this.value, required this.color});

  static const Map<int, List<Offset>> positions = {
    1: [Offset(0.5, 0.5)],
    2: [Offset(0.25, 0.25), Offset(0.75, 0.75)],
    3: [Offset(0.25, 0.25), Offset(0.5, 0.5), Offset(0.75, 0.75)],
    4: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    5: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.5, 0.5),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    6: [
      Offset(0.25, 0.2),
      Offset(0.75, 0.2),
      Offset(0.25, 0.5),
      Offset(0.75, 0.5),
      Offset(0.25, 0.8),
      Offset(0.75, 0.8),
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.075;

    for (final position in positions[value]!) {
      canvas.drawCircle(
        Offset(position.dx * size.width, position.dy * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PipPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
