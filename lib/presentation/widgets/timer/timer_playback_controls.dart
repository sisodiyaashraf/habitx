import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';

/// The glassmorphic playback controls pod for the timer screen.
class TimerPlaybackControls extends StatelessWidget {
  final HabitProvider provider;
  final int initialMinutes;
  final Color iconColor;

  const TimerPlaybackControls({
    super.key,
    required this.provider,
    required this.initialMinutes,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 280,
      height: 100,
      borderRadius: 50,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.3), Colors.transparent],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.replay_rounded, color: iconColor, size: 28),
            onPressed: () => provider.startTaskTimer("", initialMinutes),
          ),
          _mainToggleButton(),
          IconButton(
            icon: Icon(Icons.add_circle_outline_outlined, color: iconColor, size: 28),
            onPressed: () => provider.addSeconds(60),
          ),
        ],
      ),
    );
  }

  Widget _mainToggleButton() {
    return GestureDetector(
      onTap: () => provider.toggleTimer(initialMinutes),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          provider.isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
