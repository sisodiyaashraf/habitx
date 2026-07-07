import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/tracking/progress_item_tile.dart';
import '../widgets/tracking/habit_detail_view.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
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
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    // Control animation based on timer state
    if (provider.isTimerRunning && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!provider.isTimerRunning && _pulseController.isAnimating) {
      _pulseController.stop();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'ACTIVITY TRACKING',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSummary(provider, textColor, subTextColor, isDark),
              const SizedBox(height: 32),

              // ENHANCED: Functional Live Focus Monitor
              _buildLiveFocusMonitor(provider, textColor, subTextColor, isDark),

              const SizedBox(height: 32),
              Text(
                "HABIT BREAKDOWN",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "Real-time progress and habit depth",
                style: TextStyle(color: subTextColor, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ...provider.allHabits.map(
                (habit) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HabitDetailView(habit: habit),
                      fullscreenDialog: true,
                    ),
                  ),
                  child: ProgressItemTile(
                    habit: habit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveFocusMonitor(
    HabitProvider provider,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
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
                      _buildSessionAction(
                        icon: provider.isTimerRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        label: provider.isTimerRunning ? "PAUSE" : "RESUME",
                        onTap: () => provider.toggleTimer(10),
                        color: activeColor,
                        isDark: isDark,
                      ),
                      _buildSessionAction(
                        icon: Icons.stop_rounded,
                        label: "STOP",
                        onTap: () => provider.stopTimer(),
                        color: Colors.redAccent.withValues(alpha: 0.8),
                        isDark: isDark,
                      ),
                      _buildSessionAction(
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

  Widget _buildSessionAction({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Color iconColor = Colors.white,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(
    HabitProvider provider,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    final double completionRate = provider.allHabits.isEmpty
        ? 0
        : (provider.allHabits.where((h) => h.isCompleted).length /
                  provider.allHabits.length) *
              100;
    return Row(
      children: [
        _buildStatCard(
          "Current Level",
          "LVL ${provider.userLevel}",
          FontAwesomeIcons.rankingStar,
          textColor,
          subTextColor,
          isDark,
          const Color(0xFFAC5DED),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          "Success Rate",
          "${completionRate.toStringAsFixed(0)}%",
          FontAwesomeIcons.circleCheck,
          textColor,
          subTextColor,
          isDark,
          const Color(0xFF00E5FF),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    dynamic icon,
    Color textColor,
    Color subTextColor,
    bool isDark,
    Color accentColor,
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 85,
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.25),
            isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.08),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.4),
            Colors.white.withValues(alpha: 0.15),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    FaIcon(icon, color: accentColor, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5,
                              shadows: isDark
                                  ? [
                                      Shadow(
                                        color: accentColor.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                      )
                                    ]
                                  : [],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
