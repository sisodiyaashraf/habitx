import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Smooth gradient sweep arc painter for the timer dial ring.
class GradientCircularPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  GradientCircularPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        colors: [secondaryColor, primaryColor],
        stops: const [0.0, 1.0],
      ).createShader(rect);

    if (progress > 0.001) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        math.pi * 2 * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GradientCircularPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
