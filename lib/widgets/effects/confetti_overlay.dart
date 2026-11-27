//lib/widgets/effects/confetti_overlay.dart

import 'dart:math';

import 'package:material_ui/material_ui.dart';

class ConfettiOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final int stuntCount;

  const ConfettiOverlay({
    super.key,
    required this.onComplete,
    required this.stuntCount,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final Random _random = Random();
  late final List<_ConfettiParticle> _particles;

  static const int _particleCount = 300;

  @override
  void initState() {
    super.initState();

    _particles = List.generate(
      _particleCount,
      (_) => _ConfettiParticle.random(_random),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _controller.forward().whenComplete(() {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;

          final textOpacity = progress < 0.8
              ? 1.0
              : ((1 - progress) / 0.2).clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _ConfettiPainter(
                  progress: progress,
                  particles: _particles,
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, 100),
                  child: Opacity(
                    opacity: textOpacity,
                    child: Text(
                      '${widget.stuntCount} Stunts',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  final double angle;
  final double speed;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final bool isCircle;

  _ConfettiParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.isCircle,
  });

  factory _ConfettiParticle.random(Random random) {
    const colors = [
      Color(0xFFFFD700),
      Color(0xFFFF5252),
      Color(0xFF40C4FF),
      Color(0xFF69F0AE),
      Color(0xFFE040FB),
      Color(0xFFFF9100),
      Color(0xFFFFFFFF),
    ];

    return _ConfettiParticle(
      angle: random.nextDouble() * 2 * pi,
      speed: 280 + random.nextDouble() * 520,
      size: 5 + random.nextDouble() * 8,
      rotation: random.nextDouble() * 2 * pi,
      rotationSpeed: (random.nextDouble() - 0.5) * 12,
      color: colors[random.nextInt(colors.length)],
      isCircle: random.nextBool(),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fade = (1 - progress).clamp(0.0, 1.0);

    for (final particle in particles) {
      final distance = particle.speed * progress;
      final gravity = 280 * progress * progress;

      final x = center.dx + cos(particle.angle) * distance;
      final y = center.dy + sin(particle.angle) * distance + gravity;

      final paint = Paint()..color = particle.color.withValues(alpha: fade);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + particle.rotationSpeed * progress);

      if (particle.isCircle) {
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 0.55,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
