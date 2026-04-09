import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class XpHeader extends StatefulWidget {
  final int currentXp;
  final int level;
  final String userName;

  const XpHeader({
    super.key,
    required this.currentXp,
    required this.level,
    required this.userName,
  });

  @override
  State<XpHeader> createState() => _XpHeaderState();
}

class _XpHeaderState extends State<XpHeader> with TickerProviderStateMixin {
  late AnimationController _lightningController;
  late AnimationController _shakeController;
  late Animation<double> _flashAnimation;

  final List<Offset> _boltPoints = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _flashAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 65,
      ),
    ]).animate(_lightningController);

    _lightningController.addListener(() {
      if (_lightningController.value > 0 && _lightningController.value < 0.2) {
        _generateBolt();
      }
      setState(() {});
    });
  }

  void _generateBolt() {
    _boltPoints.clear();
    // Start at the bolt icon position (approximate Alignment(0.8, -0.6))
    double x = 0.85;
    double y = 0.25;

    _boltPoints.add(Offset(x, y));
    for (int i = 0; i < 8; i++) {
      x += (_random.nextDouble() - 0.5) * 0.4;
      y += 0.15;
      _boltPoints.add(Offset(x, y));
    }
  }

  void _triggerLightning() async {
    _lightningController.forward(from: 0.0);
    _shakeController.forward(from: 0.0).then((_) => _shakeController.reverse());

    // Jagged haptic sequence to match the lightning flicker
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.vibrate(); // The final boom
  }

  @override
  void dispose() {
    _lightningController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double progress = (widget.currentXp % 100) / 100;
    int xpToNextLevel = 100 - (widget.currentXp % 100);

    return AnimatedBuilder(
      animation: Listenable.merge([_lightningController, _shakeController]),
      builder: (context, child) {
        // Screen Shake Logic
        final double shake =
            math.sin(_shakeController.value * math.pi * 10) *
            4 *
            (1 - _shakeController.value);

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Stack(
            children: [
              _buildMainCard(isDark, progress, xpToNextLevel),
              // Jagged Lightning Painter
              if (_flashAnimation.value > 0)
                IgnorePointer(
                  child: CustomPaint(
                    size: const Size(double.infinity, 180),
                    painter: LightningPainter(
                      points: _boltPoints,
                      opacity: _flashAnimation.value,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainCard(bool isDark, double progress, int xpToNextLevel) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white54 : Colors.black45;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 180,
      borderRadius: 30,
      blur: 25,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withOpacity(0.1 + (_flashAnimation.value * 0.05))
              : Colors.white.withOpacity(0.25),
          isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(
            0xFFAC5DED,
          ).withOpacity(0.5 + (_flashAnimation.value * 0.5)),
          const Color(0xFF00E5FF).withOpacity(_flashAnimation.value),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUserText(textColor, subTextColor),
                GestureDetector(
                  onTap: _triggerLightning,
                  child: _buildLevelBadge(isDark),
                ),
              ],
            ),
            const Spacer(),
            _buildProgressSection(
              progress,
              isDark,
              xpToNextLevel,
              subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserText(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(widget.userName),
          style: TextStyle(
            color: subTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Level ${widget.level}",
          style: TextStyle(
            color: textColor,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.lerp(
          const Color(0xFFAC5DED),
          const Color(0xFF00E5FF),
          _flashAnimation.value,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF00E5FF,
            ).withOpacity(_flashAnimation.value * 0.8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.4),
            blurRadius: 15,
          ),
        ],
      ),
      child: FaIcon(
        FontAwesomeIcons.bolt,
        color: Colors.white,
        size: 22 + (_flashAnimation.value * 4),
      ),
    );
  }

  Widget _buildProgressSection(
    double progress,
    bool isDark,
    int xpToNextLevel,
    Color subTextColor,
  ) {
    return Column(
      children: [
        _buildProgressBar(progress, isDark),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ASCENDING IN $xpToNextLevel XP",
              style: TextStyle(
                color: subTextColor,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(
                color: Color(0xFFAC5DED),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 12,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFAC5DED),
                    Color.lerp(
                      const Color(0xFF7B61FF),
                      const Color(0xFF00E5FF),
                      _flashAnimation.value,
                    )!,
                    const Color(0xFFAC5DED),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.5),
                    blurRadius: 10 + (_flashAnimation.value * 10),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getGreeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING, ${name.toUpperCase()}";
    if (hour < 17) return "GOOD AFTERNOON, ${name.toUpperCase()}";
    return "GOOD EVENING, ${name.toUpperCase()}";
  }
}

class LightningPainter extends CustomPainter {
  final List<Offset> points;
  final double opacity;

  LightningPainter({required this.points, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || opacity <= 0) return;

    final Paint glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(opacity * 0.5)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final Paint boltPaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
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
