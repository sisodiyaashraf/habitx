import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'lightning_painter.dart';
import 'xp_header_widgets.dart';

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
        tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
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
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.vibrate();
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
        final double shake =
            math.sin(_shakeController.value * math.pi * 10) *
            4 *
            (1 - _shakeController.value);

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Stack(
            children: [
              _buildMainCard(isDark, progress, xpToNextLevel),
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
              ? Colors.white.withValues(alpha: 0.1 + (_flashAnimation.value * 0.05))
              : Colors.white.withValues(alpha: 0.25),
          isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withValues(alpha: 0.5 + (_flashAnimation.value * 0.5)),
          const Color(0xFF00E5FF).withValues(alpha: _flashAnimation.value),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: XpHeaderWidgets.userText(
                    widget.userName, widget.level, textColor, subTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: _triggerLightning,
                  child: XpHeaderWidgets.levelBadge(isDark, _flashAnimation.value),
                ),
              ],
            ),
            const Spacer(),
            XpHeaderWidgets.progressSection(
              progress, isDark, xpToNextLevel, subTextColor, _flashAnimation.value,
            ),
          ],
        ),
      ),
    );
  }
}
