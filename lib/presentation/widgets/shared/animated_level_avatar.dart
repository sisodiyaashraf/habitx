import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.97,
          end: 1.03,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.03,
          end: 0.97,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);
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
      child: ScaleTransition(
        scale: _scaleAnimation,
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
                  painter: KineticWavePainter(
                    animationValue: _controller.value,
                    colors: colors,
                    levelProgress: widget.provider.levelProgress,
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
                      Colors.white.withValues(alpha: 0.35),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    stops: const [0.2, 0.9],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          colors[0].withValues(alpha: 0.25),
                          colors[1].withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        widget.provider.userAvatarSvgPath,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // 4. THE GAMIFIED LEVEL BADGE (Bottom-Right Overlay)
                Positioned(
                  bottom: 32,
                  right: 32,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withValues(alpha: 0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.provider.userLevel.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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

/// NEW: Kinetic Wave Painter for a unique "Neon Flow" look
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

    // Draw 3 overlapping morphing waves
    _drawWave(
      canvas,
      size,
      baseRadius,
      fillHeightMultiplier,
      colors[0].withValues(alpha: 0.22),
      1.2,
      0.0,
    );
    _drawWave(
      canvas,
      size,
      baseRadius,
      fillHeightMultiplier - 0.05,
      colors.last.withValues(alpha: 0.16),
      1.6,
      math.pi / 2,
    );
    _drawWave(
      canvas,
      size,
      baseRadius,
      fillHeightMultiplier + 0.05,
      colors[0].withValues(alpha: 0.10),
      0.8,
      math.pi,
    );

    canvas.restore();
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double radius,
    double fillHeightMultiplier,
    Color color,
    double frequency,
    double phaseShift,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double width = size.width;
    final double height = size.height;

    // Fluid height level
    final double fillHeight = height * (1.0 - fillHeightMultiplier);

    path.moveTo(0, height);
    for (double x = 0; x <= width; x += 3) {
      final double y =
          fillHeight +
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
