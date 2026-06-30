import 'package:flutter/material.dart';
import 'dart:math' as math;

class HabitTimerDial extends StatefulWidget {
  final double progress;
  final String displayTime;
  final VoidCallback? onTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;

  const HabitTimerDial({
    super.key,
    required this.progress,
    required this.displayTime,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  @override
  State<HabitTimerDial> createState() => _HabitTimerDialState();
}

class _HabitTimerDialState extends State<HabitTimerDial> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _rippleController;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;

  @override
  void initState() {
    super.initState();

    // springy scale animation for the core
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // expanding energy ripple
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _rippleScale = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOutCubic),
    );
    _rippleOpacity = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }

    // Trigger spring squeeze-and-bounce
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Trigger dual expanding ripple
    _rippleController.reset();
    _rippleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black45;

    return GestureDetector(
      onTap: _handleTap,
      onLongPressStart: (_) {
        if (widget.onLongPressStart != null) {
          widget.onLongPressStart!();
        }
      },
      onLongPressEnd: (_) {
        if (widget.onLongPressEnd != null) {
          widget.onLongPressEnd!();
        }
      },
      onLongPressCancel: () {
        if (widget.onLongPressEnd != null) {
          widget.onLongPressEnd!();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
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

          // 2. TAPPED DUAL RIPPLE EFFECT (Behind the ring/core)
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer expanding circle outline
                  Transform.scale(
                    scale: _rippleScale.value,
                    child: Opacity(
                      opacity: _rippleOpacity.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF7B61FF).withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Inner blooming color glow
                  Transform.scale(
                    scale: 1.0 + (_rippleScale.value - 1.0) * 0.6,
                    child: Opacity(
                      opacity: _rippleOpacity.value * 0.7,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFAC5DED).withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 3. Background Track (The "Groove")
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

          // 4. Dynamic Gradient Progress Ring
          SizedBox(
            width: 230,
            height: 230,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: widget.progress),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: -math.pi / 2, // Starts the gradient at 12 o'clock
                  child: CustomPaint(
                    painter: _GradientCircularPainter(
                      progress: value,
                      primaryColor: const Color(0xFFAC5DED),
                      secondaryColor: const Color(0xFF7B61FF),
                      strokeWidth: 14,
                    ),
                  ),
                );
              },
            ),
          ),

          // 5. Inner Glass Core with Scale Transition
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
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
                      widget.displayTime,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "FOCUSING",
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
