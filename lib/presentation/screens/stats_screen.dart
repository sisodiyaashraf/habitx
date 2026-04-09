import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/habit_provider.dart';
import '../widgets/tracking/weekly_bar_chart.dart';
import '../widgets/tracking/elite_heatmap.dart';
import '../widgets/tracking/achievement_tracker.dart';
import '../widgets/shared/glass_background.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "ANALYTICS",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GlassBackground(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ELITE RANK CARD ---
                _buildGlobalRankCard(provider, textColor, subTextColor, isDark),
                const SizedBox(height: 24),

                // --- QUICK STATS ---
                _buildQuickStatsRow(provider, textColor, subTextColor, isDark),
                const SizedBox(height: 32),

                // --- CONSISTENCY CHART ---
                _buildSectionHeader("CONSISTENCY SCORE", "7-DAY", subTextColor),
                const SizedBox(height: 16),
                const WeeklyBarChart(),

                const SizedBox(height: 32),

                // --- ACHIEVEMENTS ---
                _buildSectionHeader(
                  "ELITE ACHIEVEMENTS",
                  "${_calculateUnlockedCount(provider)}/6",
                  subTextColor,
                ),
                const SizedBox(height: 16),
                AchievementTracker(provider: provider),

                const SizedBox(height: 32),

                // --- HEATMAP ---
                _buildSectionHeader(
                  "ACTIVITY INTENSITY",
                  "35-DAY",
                  subTextColor,
                ),
                const SizedBox(height: 16),
                const EliteHeatmap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalRankCard(
    HabitProvider provider,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    double progress = (provider.userXP % 100) / 100;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 140,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.3),
          isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [const Color(0xFFAC5DED).withOpacity(0.5), Colors.white24],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAC5DED),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFAC5DED).withOpacity(0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.crown,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level ${provider.userLevel} Builder",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Elite Performance Status",
                        style: TextStyle(
                          color: subTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) => Text(
                    "${(value * 100).toInt()}%",
                    style: const TextStyle(
                      color: Color(0xFFAC5DED),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.white10
                        : Colors.black.withOpacity(0.05),
                    color: const Color(0xFFAC5DED),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow(
    HabitProvider provider,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    final int done = provider.allHabits.where((h) => h.isCompleted).length;
    final int total = provider.allHabits.length;
    final int maxStreak = provider.allHabits.isEmpty
        ? 0
        : provider.allHabits
              .map((h) => h.streak)
              .reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statBox(
          "XP",
          "${provider.userXP}",
          FontAwesomeIcons.bolt,
          textColor,
          subTextColor,
          isDark,
        ),
        _statBox(
          "STREAK",
          "$maxStreak",
          FontAwesomeIcons.fire,
          textColor,
          subTextColor,
          isDark,
        ),
        _statBox(
          "DONE",
          "$done/$total",
          FontAwesomeIcons.checkDouble,
          textColor,
          subTextColor,
          isDark,
        ),
      ],
    );
  }

  // FIX: Icon type changed to dynamic to prevent FaIconData casting error
  Widget _statBox(
    String label,
    String value,
    dynamic icon,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: subTextColor,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateUnlockedCount(HabitProvider provider) {
    int count = 0;
    final int done = provider.allHabits.where((h) => h.isCompleted).length;
    final int maxStreak = provider.allHabits.isEmpty
        ? 0
        : provider.allHabits
              .map((h) => h.streak)
              .reduce((a, b) => a > b ? a : b);

    if (done >= 1) count++;
    if (maxStreak >= 3) count++;
    if (maxStreak >= 7) count++;
    if (done >= 50) count++;
    if (done >= 100) count++;
    if (provider.userLevel >= 20) count++;
    return count;
  }

  Widget _buildSectionHeader(
    String title,
    String trailing,
    Color subTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: subTextColor,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFAC5DED).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            trailing,
            style: const TextStyle(
              color: Color(0xFFAC5DED),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
