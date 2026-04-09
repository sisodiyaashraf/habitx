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
                    title: habit.name,
                    progress: "${habit.streak} day streak",
                    icon: habit.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
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

    return GlassmorphicContainer(
      width: double.infinity,
      height: 180, // Increased height for controls
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withOpacity(0.2),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: const LinearGradient(
        colors: [Color(0xFFAC5DED), Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FadeTransition(
                            opacity: _pulseController,
                            child: const Icon(
                              Icons.circle,
                              color: Colors.redAccent,
                              size: 8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "LIVE SESSION",
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.isTimerRunning ? "Focusing..." : "Ready",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white10
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    timeStr,
                    style: const TextStyle(
                      color: Color(0xFFAC5DED),
                      fontSize: 28,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // NEW: Quick Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSessionAction(
                  icon: provider.isTimerRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  label: provider.isTimerRunning ? "Pause" : "Resume",
                  onTap: () =>
                      provider.toggleTimer(10), // Defaulting to 10 if new
                  color: const Color(0xFFAC5DED),
                ),
                _buildSessionAction(
                  icon: Icons.stop_rounded,
                  label: "Stop",
                  onTap: () => provider.stopTimer(),
                  color: Colors.redAccent.withOpacity(0.8),
                ),
                _buildSessionAction(
                  icon: Icons.add_rounded,
                  label: "+1m",
                  onTap: () => provider.addSeconds(60),
                  color: textColor.withOpacity(0.1),
                  iconColor: textColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionAction({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
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
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          "Success Rate",
          "${completionRate.toStringAsFixed(0)}%",
          FontAwesomeIcons.circleCheck,
          textColor,
          subTextColor,
          isDark,
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
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          colors: [
            isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withOpacity(0.3),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
