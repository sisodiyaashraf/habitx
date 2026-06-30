import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Raindrop {
  double x;
  double y;
  double speed;
  double length;
  double opacity;

  Raindrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.opacity,
  });
}

class WindStreak {
  double x;
  double y;
  double speed;
  double width;
  double length;
  double opacity;
  double waveOffset;

  WindStreak({
    required this.x,
    required this.y,
    required this.speed,
    required this.width,
    required this.length,
    required this.opacity,
    required this.waveOffset,
  });
}

class StormOverlay extends StatefulWidget {
  final Widget child;
  final bool isStormActive;

  const StormOverlay({
    super.key,
    required this.child,
    required this.isStormActive,
  });

  @override
  State<StormOverlay> createState() => _StormOverlayState();
}

class _StormOverlayState extends State<StormOverlay> with SingleTickerProviderStateMixin {
  List<Raindrop> _raindrops = [];
  List<WindStreak> _windStreaks = [];
  double _lightningOpacity = 0.0;
  late AnimationController _tickerController;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _tickerController.addListener(_updateAnimation);
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    if (!widget.isStormActive) {
      if (_raindrops.isNotEmpty) _raindrops.clear();
      if (_windStreaks.isNotEmpty) _windStreaks.clear();
      if (_lightningOpacity > 0) _lightningOpacity = 0.0;
      return;
    }

    final Size size = MediaQuery.of(context).size;
    if (size.width == 0 || size.height == 0) return;

    // Initialize particles if empty
    if (_raindrops.isEmpty) {
      _raindrops = List.generate(
        100,
        (index) => _createRaindrop(size.width, size.height, isInitial: true),
      );
    }
    if (_windStreaks.isEmpty) {
      _windStreaks = List.generate(
        6,
        (index) => _createWindStreak(size.width, size.height, isInitial: true),
      );
    }

    // Update Rain
    for (var drop in _raindrops) {
      drop.y += drop.speed;
      drop.x -= drop.speed * 0.18; // wind slant
      if (drop.y > size.height || drop.x < -20) {
        var newDrop = _createRaindrop(size.width, size.height, isInitial: false);
        drop.x = newDrop.x;
        drop.y = newDrop.y;
        drop.speed = newDrop.speed;
        drop.length = newDrop.length;
        drop.opacity = newDrop.opacity;
      }
    }

    // Update Wind
    for (var streak in _windStreaks) {
      streak.x -= streak.speed;
      if (streak.x < -streak.length) {
        var newStreak = _createWindStreak(size.width, size.height, isInitial: false);
        streak.x = newStreak.x;
        streak.y = newStreak.y;
        streak.speed = newStreak.speed;
        streak.length = newStreak.length;
        streak.opacity = newStreak.opacity;
        streak.waveOffset = newStreak.waveOffset;
      }
    }

    // Update Lightning & Rumble Haptics
    if (_lightningOpacity > 0.0) {
      _lightningOpacity -= 0.12; // fast fade out
      if (_lightningOpacity < 0.0) _lightningOpacity = 0.0;
    } else {
      // 2% chance per frame of a lightning flash
      if (_random.nextDouble() < 0.02) {
        _lightningOpacity = 0.7 + _random.nextDouble() * 0.3;
        
        // Thunder rumble vibration
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 80), () {
          HapticFeedback.mediumImpact();
        });
      }
    }

    setState(() {});
  }

  Raindrop _createRaindrop(double width, double height, {required bool isInitial}) {
    return Raindrop(
      x: _random.nextDouble() * (width + 120),
      y: isInitial ? _random.nextDouble() * height : -50,
      speed: 18.0 + _random.nextDouble() * 12.0,
      length: 15.0 + _random.nextDouble() * 15.0,
      opacity: 0.15 + _random.nextDouble() * 0.45,
    );
  }

  WindStreak _createWindStreak(double width, double height, {required bool isInitial}) {
    return WindStreak(
      x: isInitial ? _random.nextDouble() * width : width + 50,
      y: _random.nextDouble() * height,
      speed: 10.0 + _random.nextDouble() * 10.0,
      width: 1.0 + _random.nextDouble() * 2.0,
      length: 100.0 + _random.nextDouble() * 120.0,
      opacity: 0.05 + _random.nextDouble() * 0.12,
      waveOffset: _random.nextDouble() * 2 * math.pi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isStormActive) ...[
          // Storm particles
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: StormPainter(
                  raindrops: _raindrops,
                  windStreaks: _windStreaks,
                ),
              ),
            ),
          ),
          // Lightning screen flash overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: _lightningOpacity,
                child: Container(
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class StormPainter extends CustomPainter {
  final List<Raindrop> raindrops;
  final List<WindStreak> windStreaks;

  StormPainter({required this.raindrops, required this.windStreaks});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Rain
    final rainPaint = Paint()..strokeCap = StrokeCap.round;
    for (var drop in raindrops) {
      rainPaint.color = Colors.blueGrey.withOpacity(drop.opacity);
      rainPaint.strokeWidth = 1.0 + (drop.speed / 15.0);
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x - drop.length * 0.18, drop.y + drop.length),
        rainPaint,
      );
    }

    // 2. Draw Wind
    final windPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var streak in windStreaks) {
      windPaint.color = Colors.white.withOpacity(streak.opacity);
      windPaint.strokeWidth = streak.width;

      final path = Path();
      path.moveTo(streak.x, streak.y);
      for (double dx = 0; dx < streak.length; dx += 12) {
        final double py = streak.y + math.sin((streak.x + dx) * 0.025 + streak.waveOffset) * 12;
        path.lineTo(streak.x + dx, py);
      }
      canvas.drawPath(path, windPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StormPainter oldDelegate) => true;
}
