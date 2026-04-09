import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../providers/habit_provider.dart';

class DailyProgressCard extends StatefulWidget {
  const DailyProgressCard({super.key, required double progress});

  @override
  State<DailyProgressCard> createState() => _DailyProgressCardState();
}

class _DailyProgressCardState extends State<DailyProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habits = provider.allHabits;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int completedCount = habits.where((h) => h.isCompleted).length;
    double progress = habits.isEmpty ? 0 : completedCount / habits.length;
    int percentage = (progress * 100).toInt();

    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 150, // Slightly taller for better balance
      borderRadius: 35,
      blur: 30,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.2),
          isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withOpacity(0.6),
          const Color(0xFF7B61FF).withOpacity(0.1),
        ],
      ),
      child: Stack(
        children: [
          // Background "Shine" effect for completed state
          if (progress >= 1.0)
            Positioned(
              right: -20,
              top: -20,
              child: FaIcon(
                FontAwesomeIcons.trophy,
                size: 100,
                color: const Color(0xFFAC5DED).withOpacity(0.05),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildAnimatedCircularProgress(progress, percentage, isDark),
                const SizedBox(width: 28),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DAILY PROGRESS",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$completedCount of ${habits.length} habits locked in",
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildDynamicGoalBadge(progress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircularProgress(
    double progress,
    int percentage,
    bool isDark,
  ) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Breathing Glow Effect
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(
                      progress > 0
                          ? (0.2 + (_glowController.value * 0.15))
                          : 0.0,
                    ),
                    blurRadius: 15 + (_glowController.value * 10),
                    spreadRadius: 2 + (_glowController.value * 2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 85,
              width: 85,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                color: const Color(0xFFAC5DED),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$percentage",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Text(
                  "%",
                  style: const TextStyle(
                    color: Color(0xFFAC5DED),
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDynamicGoalBadge(double progress) {
    String message = "INITIALIZING MISSION";
    dynamic icon = FontAwesomeIcons.bolt;
    Color accent = const Color(0xFFAC5DED);

    if (progress > 0 && progress < 0.5) {
      message = "MOMENTUM BUILDING";
      icon = FontAwesomeIcons.fire;
    } else if (progress >= 0.5 && progress < 1.0) {
      message = "ELITE PERFORMANCE";
      icon = FontAwesomeIcons.rankingStar;
    } else if (progress >= 1.0) {
      message = "MISSION ACCOMPLISHED";
      icon = FontAwesomeIcons.circleCheck;
      accent = Colors.greenAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: accent, size: 10),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: accent,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
