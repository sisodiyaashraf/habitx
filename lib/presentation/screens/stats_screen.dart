import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../widgets/tracking/weekly_bar_chart.dart';
import '../widgets/tracking/elite_heatmap.dart';
import '../widgets/tracking/achievement_tracker.dart';
import '../widgets/tracking/elite_performance_card.dart';
import '../widgets/tracking/quick_stats_row.dart';
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
                ElitePerformanceCard(provider: provider),
                const SizedBox(height: 24),

                // --- QUICK STATS ---
                QuickStatsRow(
                  provider: provider,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 32),

                // --- CONSISTENCY CHART ---
                _buildSectionHeader("CONSISTENCY SCORE", "7-DAY", subTextColor),
                const SizedBox(height: 16),
                const WeeklyBarChart(),

                const SizedBox(height: 32),

                // --- ACHIEVEMENTS ---
                _buildSectionHeader(
                  "ELITE ACHIEVEMENTS",
                  "${_calculateUnlockedCount(provider)}/${AchievementTracker.getAchievementCount()}",
                  subTextColor,
                ),
                const SizedBox(height: 16),
                AchievementTracker(provider: provider),

                const SizedBox(height: 32),

                // --- HEATMAP ---
                _buildSectionHeader(
                  "ACTIVITY INTENSITY",
                  "SELECTABLE MATRIX",
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
} // CLOSE StatsScreen





int _calculateUnlockedCount(HabitProvider provider) {
  final achievements = AchievementTracker.getAchievementData(provider);
  return achievements.where((a) => a['unlocked'] as bool).length;
}

Widget _buildSectionHeader(String title, String trailing, Color subTextColor) {
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
          color: const Color(0xFFAC5DED).withValues(alpha: 0.12),
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
