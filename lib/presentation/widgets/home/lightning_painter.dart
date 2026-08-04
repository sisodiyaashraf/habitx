import 'package:flutter/material.dart';

class LightningPainter extends CustomPainter {
  final List<Offset> points;
  final double opacity;

  LightningPainter({required this.points, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || opacity <= 0) return;

    final Paint glowPaint = Paint()
      ..color = const Color.fromARGB(
        255,
        182,
        135,
        182,
      ).withValues(alpha: opacity * 0.5)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final Paint boltPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(points[0].dx * size.width, points[0].dy * size.height);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, boltPaint);
  }

  @override
  bool shouldRepaint(LightningPainter oldDelegate) => true;
}
