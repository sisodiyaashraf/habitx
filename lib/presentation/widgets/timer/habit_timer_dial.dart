import 'package:flutter/material.dart';
import 'dart:math' as math;

class HabitTimerDial extends StatelessWidget {
  final double progress;
  final String displayTime;

  const HabitTimerDial({
    super.key,
    required this.progress,
    required this.displayTime,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Soft Ambient Aura
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFAC5DED).withOpacity(0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // 2. Background Track (The "Groove")
        Container(
          width: 230,
          height: 230,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withOpacity(0.04),
              width: 14,
            ),
          ),
        ),

        // 3. Dynamic Gradient Progress Ring
        SizedBox(
          width: 230,
          height: 230,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: progress),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: -math.pi / 2, // Starts the gradient at 12 o'clock
                child: CustomPaint(
                  painter: _GradientCircularPainter(
                    progress: value, // Fixes the "progress isn't defined" error
                    primaryColor: const Color(0xFFAC5DED),
                    secondaryColor: const Color(0xFF7B61FF),
                    strokeWidth: 14,
                  ),
                ),
              );
            },
          ),
        ),

        // 4. Inner Glass Core with Pulse Effect
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the actual countdown time in the center for focus
                Text(
                  displayTime,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "FOCUSING",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Painter for a perfectly smooth Sweep Gradient ring
class _GradientCircularPainter extends CustomPainter {
  final double progress; // Progress passed from TweenAnimationBuilder
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  _GradientCircularPainter({
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
      ..style = PaintingStyle.stroke;

    // Apply the Sweep Gradient shader
    paint.shader = SweepGradient(
      colors: [secondaryColor, primaryColor],
      stops: const [0.0, 1.0],
    ).createShader(rect);

    // Draw the arc based on current animated progress
    // We only draw if progress is greater than a tiny threshold to avoid cap artifacts
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
  bool shouldRepaint(covariant _GradientCircularPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
