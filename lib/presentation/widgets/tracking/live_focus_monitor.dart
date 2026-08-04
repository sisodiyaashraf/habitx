import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';
import 'focus_session_action.dart';

class LiveFocusMonitor extends StatefulWidget {
  final HabitProvider provider;
  final Color textColor;
  final Color subTextColor;
  final bool isDark;

  const LiveFocusMonitor({
    super.key,
    required this.provider,
    required this.textColor,
    required this.subTextColor,
    required this.isDark,
  });

  @override
  State<LiveFocusMonitor> createState() => _LiveFocusMonitorState();
}

class _LiveFocusMonitorState extends State<LiveFocusMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final textColor = widget.textColor;
    final subTextColor = widget.subTextColor;
    final isDark = widget.isDark;

    // Control animation based on timer state
    if (provider.isTimerRunning && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!provider.isTimerRunning && _pulseController.isAnimating) {
      _pulseController.stop();
    }

    final minutes = (provider.currentSeconds / 60).floor();
    final seconds = provider.currentSeconds % 60;
    final timeStr =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    final activeColor = const Color(0xFFAC5DED);
    final accentColor = const Color(0xFF00E5FF);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double scale = provider.isTimerRunning
            ? 1.0 + (_pulseController.value * 0.015)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 200,
            borderRadius: 25,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                provider.isTimerRunning
                    ? activeColor.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                isDark ? Colors.black26 : Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                provider.isTimerRunning ? accentColor : activeColor,
                Colors.white12,
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          provider.isTimerRunning
                              ? FadeTransition(
                                  opacity: _pulseController,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent,
                                          blurRadius: 6,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: textColor.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                          const SizedBox(width: 8),
                          Text(
                            provider.isTimerRunning
                                ? "LIVE FOCUS SESSION ACTIVE"
                                : "STANDBY FOCUS MODE",
                            style: TextStyle(
                              color: provider.isTimerRunning
                                  ? activeColor
                                  : subTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: provider.isTimerRunning
                              ? accentColor.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: provider.isTimerRunning
                                ? accentColor.withValues(alpha: 0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          provider.isTimerRunning ? "SYNCING XP" : "OFFLINE",
                          style: TextStyle(
                            color: provider.isTimerRunning ? accentColor : subTextColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.isTimerRunning ? "NEURAL COGNITION" : "PREPARE MIND",
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.isTimerRunning ? "Focusing..." : "Ready to Start",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black26
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: provider.isTimerRunning
                                ? activeColor.withValues(alpha: 0.4)
                                : Colors.white10,
                          ),
                          boxShadow: provider.isTimerRunning
                              ? [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          timeStr,
                          style: TextStyle(
                            color: provider.isTimerRunning ? accentColor : activeColor,
                            fontSize: 30,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            shadows: provider.isTimerRunning
                                ? [
                                    Shadow(
                                      color: accentColor.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    )
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FocusSessionAction(
                        icon: provider.isTimerRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        label: provider.isTimerRunning ? "PAUSE" : "RESUME",
                        onTap: () => provider.toggleTimer(10),
                        color: activeColor,
                        isDark: isDark,
                      ),
                      FocusSessionAction(
                        icon: Icons.stop_rounded,
                        label: "STOP",
                        onTap: () => provider.stopTimer(),
                        color: Colors.redAccent.withValues(alpha: 0.8),
                        isDark: isDark,
                      ),
                      FocusSessionAction(
                        icon: Icons.add_rounded,
                        label: "+1 MIN",
                        onTap: () => provider.addSeconds(60),
                        color: const Color(0xFF00E5FF),
                        iconColor: Colors.black87,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
