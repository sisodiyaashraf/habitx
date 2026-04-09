import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';

class AnimatedLevelAvatar extends StatefulWidget {
  final HabitProvider provider;
  const AnimatedLevelAvatar({super.key, required this.provider});

  @override
  State<AnimatedLevelAvatar> createState() => _AnimatedLevelAvatarState();
}

class _AnimatedLevelAvatarState extends State<AnimatedLevelAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // NEW: Hyper-Modern "Aura" Palettes
  final List<List<Color>> _gradientPalettes = [
    [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)], // Electric Violet
    [const Color(0xFF00F260), const Color(0xFF0575E6)], // Neo Mint to Deep Sea
    [const Color(0xFFFF416C), const Color(0xFFFF4B2B)], // Volcanic Sunset
    [
      const Color(0xFF1FA2FF),
      const Color(0xFF12D8FA),
      const Color(0xFFA6FFCB),
    ], // Aurora Borealis
    [const Color(0xFFf7ff00), const Color(0xFFdb36a4)], // Cyberpunk Candy
  ];

  int _paletteIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.provider.isHapticsEnabled) {
      HapticFeedback.selectionClick();
    }
    setState(() {
      _paletteIndex = (_paletteIndex + 1) % _gradientPalettes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradientPalettes[_paletteIndex];

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 1. DUAL ORBIT SYSTEM (Kinetic Energy)
              _buildOrbit(
                210,
                -_controller.value * 2 * math.pi,
                colors,
                15,
                0.15,
              ),
              _buildOrbit(
                185,
                _controller.value * 4 * math.pi,
                colors.reversed.toList(),
                10,
                0.3,
              ),

              // 2. MODERN GRADIENT PROGRESS (Liquid Glow)
              CustomPaint(
                size: const Size(158, 158),
                painter: LiquidProgressPainter(
                  progress: widget.provider.levelProgress,
                  colors: colors,
                ),
              ),

              // 3. THE GLASS CORE (Hyper-Glassmorphism)
              GlassmorphicContainer(
                width: 130,
                height: 130,
                borderRadius: 65,
                blur: 35,
                alignment: Alignment.center,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.02),
                  ],
                  stops: [
                    (_controller.value - 0.4).clamp(0.0, 1.0),
                    (_controller.value + 0.4).clamp(0.0, 1.0),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CORE",
                      style: TextStyle(
                        color: colors[0].withOpacity(0.5),
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.provider.userLevel.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 58,
                        fontWeight: FontWeight.w900,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrbit(
    double size,
    double angle,
    List<Color> colors,
    int dashCount,
    double opacity,
  ) {
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: Size(size, size),
        painter: GradientOrbitPainter(
          colors: colors,
          dashCount: dashCount,
          opacity: opacity,
        ),
      ),
    );
  }
}

/// NEW: Liquid Progress Painter for a unique "Neon Flow" look
class LiquidProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  LiquidProgressPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Subtle Shadow/Glow under the progress
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. Gradient Progress Arc
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [...colors, colors[0]],
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
      ).createShader(rect)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.colors != colors;
}

/// Keep your GradientOrbitPainter...
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
        paint..color = colors[0].withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(GradientOrbitPainter oldDelegate) => true;
}
