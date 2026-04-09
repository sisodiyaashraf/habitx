import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../providers/habit_provider.dart';
import '../widgets/timer/habit_timer_dial.dart';
import '../widgets/shared/glass_background.dart';

class HabitTimerScreen extends StatelessWidget {
  final String habitName;
  final int initialMinutes;

  const HabitTimerScreen({
    super.key,
    required this.habitName,
    this.initialMinutes = 10,
  });

  @override
  Widget build(BuildContext context) {
    // Watch provider to react to the 1-second timer ticks
    final provider = context.watch<HabitProvider>();
    final bool isRunning = provider.isTimerRunning;

    // Formatting for Onyx visibility
    String minutes = (provider.currentSeconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (provider.currentSeconds % 60).toString().padLeft(2, '0');

    // Progress calculation for the sweep dial
    double progress = (initialMinutes * 60) > 0
        ? provider.currentSeconds / (initialMinutes * 60)
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          habitName.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            // FIXED: Centers everything horizontally in the Column
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Header Status
              _buildFocusHeader(isRunning),

              const Spacer(),

              // FIXED: Explicit centering for the Dial Stack
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildGlowEffect(isRunning, progress),
                    HabitTimerDial(
                      progress: progress,
                      displayTime: "$minutes:$seconds",
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // FIXED: Time details text alignment
              _buildTimeDetails(minutes, seconds),

              const SizedBox(height: 40),

              // FIXED: Centered Control Pod
              Center(child: _buildPlaybackControls(provider)),

              const SizedBox(height: 40),

              // Motivational Footer
              _buildMotivationalQuote(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusHeader(bool isRunning) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isRunning
            ? const Color(0xFFAC5DED).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            isRunning
                ? Icons.center_focus_strong_rounded
                : Icons.timer_outlined,
            color: const Color(0xFFAC5DED),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            isRunning ? "DEEP FOCUS ACTIVE" : "PREPARING SESSION",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowEffect(bool isRunning, double progress) {
    if (!isRunning) return const SizedBox.shrink();
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.25 * progress),
            blurRadius: 70,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDetails(String min, String sec) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "REMAINING",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black38,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        Text(
          "$min:$sec",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 90,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(HabitProvider provider) {
    return GlassmorphicContainer(
      width: 280,
      height: 100,
      borderRadius: 50,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.transparent],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _circleIconButton(Icons.replay_rounded, () {
            provider.startTaskTimer("", initialMinutes);
          }),
          _buildMainToggleButton(provider),
          _circleIconButton(
            Icons.add_circle_outline_outlined, // Improved Icon
            () => provider.addSeconds(60),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.black54, size: 28),
      onPressed: onTap,
    );
  }

  Widget _buildMainToggleButton(HabitProvider provider) {
    bool isRunning = provider.isTimerRunning;
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
              color: const Color(0xFFAC5DED).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "“Excellence is not an act, but a habit.”",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black45,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
