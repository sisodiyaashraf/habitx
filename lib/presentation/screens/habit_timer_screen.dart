import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../providers/habit_provider.dart';
import '../../core/utils/haptic_feedback_helper.dart';
import '../widgets/timer/habit_timer_dial.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/timer/storm_overlay.dart';

class HabitTimerScreen extends StatefulWidget {
  final String habitName;
  final int initialMinutes;

  const HabitTimerScreen({
    super.key,
    required this.habitName,
    this.initialMinutes = 10,
  });

  @override
  State<HabitTimerScreen> createState() => _HabitTimerScreenState();
}

class _HabitTimerScreenState extends State<HabitTimerScreen> {
  bool _isStormActive = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final hintTextColor = isDark ? Colors.white38 : Colors.black38;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    // Watch provider to react to the 1-second timer ticks
    final provider = context.watch<HabitProvider>();
    final bool isRunning = provider.isTimerRunning;

    // Formatting for Onyx visibility
    String minutes = (provider.currentSeconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (provider.currentSeconds % 60).toString().padLeft(2, '0');

    // Progress calculation for the sweep dial
    double progress = (widget.initialMinutes * 60) > 0
        ? provider.currentSeconds / (widget.initialMinutes * 60)
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.habitName.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StormOverlay(
        isStormActive: _isStormActive,
        child: GlassBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
  
                  // Header Status
                  _buildFocusHeader(isRunning, subTextColor),
  
                  const SizedBox(height: 20),
  
                  // FIXED: Explicit centering for the Dial Stack
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildGlowEffect(isRunning, progress),
                        HabitTimerDial(
                          progress: progress,
                          displayTime: "$minutes:$seconds",
                          onTap: () {
                            if (provider.isHapticsEnabled) {
                              HapticHelper.selection();
                            }
                          },
                          onLongPressStart: () {
                            setState(() {
                              _isStormActive = true;
                            });
                          },
                          onLongPressEnd: () {
                            setState(() {
                              _isStormActive = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // FIXED: Time details text alignment
                _buildTimeDetails(minutes, seconds, textColor, hintTextColor),

                const SizedBox(height: 24),

                // FIXED: Centered Control Pod
                Center(child: _buildPlaybackControls(provider, iconColor)),

                const SizedBox(height: 24),

                // Motivational Footer
                _buildMotivationalQuote(subTextColor),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildFocusHeader(bool isRunning, Color color) {
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
            style: TextStyle(
              color: color,
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

  Widget _buildTimeDetails(String min, String sec, Color textColor, Color subTextColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "REMAINING",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        Text(
          "$min:$sec",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 90,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: -5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(HabitProvider provider, Color iconColor) {
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
          _circleIconButton(Icons.replay_rounded, iconColor, () {
            provider.startTaskTimer("", widget.initialMinutes);
          }),
          _buildMainToggleButton(provider),
          _circleIconButton(
            Icons.add_circle_outline_outlined, // Improved Icon
            iconColor,
            () => provider.addSeconds(60),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 28),
      onPressed: onTap,
    );
  }

  Widget _buildMainToggleButton(HabitProvider provider) {
    bool isRunning = provider.isTimerRunning;
    return GestureDetector(
      onTap: () => provider.toggleTimer(widget.initialMinutes),
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

  Widget _buildMotivationalQuote(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "“Excellence is not an act, but a habit.”",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
