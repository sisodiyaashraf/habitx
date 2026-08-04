import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Painters for AnimatedLevelAvatar — kinetic wave fill and dashed orbit ring.
class KineticWavePainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;
  final double levelProgress;

  KineticWavePainter({
    required this.animationValue,
    required this.colors,
    required this.levelProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2;

    canvas.save();
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: baseRadius));
    canvas.clipPath(clipPath);

    final fillHeightMultiplier = levelProgress;

    _drawWave(canvas, size, baseRadius, fillHeightMultiplier,
        colors[0].withValues(alpha: 0.22), 1.2, 0.0);
    _drawWave(canvas, size, baseRadius, fillHeightMultiplier - 0.05,
        colors.last.withValues(alpha: 0.16), 1.6, math.pi / 2);
    _drawWave(canvas, size, baseRadius, fillHeightMultiplier + 0.05,
        colors[0].withValues(alpha: 0.10), 0.8, math.pi);

    canvas.restore();
  }

  void _drawWave(Canvas canvas, Size size, double radius,
      double fillHeightMultiplier, Color color, double frequency, double phaseShift) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double fillHeight = height * (1.0 - fillHeightMultiplier);

    path.moveTo(0, height);
    for (double x = 0; x <= width; x += 3) {
      final double y = fillHeight +
          math.sin(
                (x / width) * 2 * math.pi * frequency +
                    (animationValue * 2 * math.pi) +
                    phaseShift,
              ) *
              7;
      path.lineTo(x, y);
    }
    path.lineTo(width, height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant KineticWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.colors != colors ||
      oldDelegate.levelProgress != levelProgress;
}

class GradientOrbitPainter extends CustomPainter {
  final List<Color> colors;
  final int dashCount;
  final double opacity;

  GradientOrbitPainter({
    required this.colors,
    required this.dashCount,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(colors: colors).createShader(rect)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final double sweepAngle = (2 * math.pi / dashCount) * 0.3;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * (2 * math.pi / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint..color = colors[0].withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(GradientOrbitPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.dashCount != dashCount ||
      oldDelegate.opacity != opacity;
}
