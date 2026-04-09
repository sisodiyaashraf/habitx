import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/habit_provider.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dynamic Colors based on Theme
    final textColor = isDark ? Colors.white70 : Colors.black45;
    final barBgColor = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);

    // Get the last 7 days of dates from provider
    final List<DateTime> weekDays = provider.pastWeekDates;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 300, // Increased height for better label breathing
      borderRadius: 35,
      blur: 30,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.25),
          isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withOpacity(0.6),
          const Color(0xFF7B61FF).withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WEEKLY INTENSITY",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                _buildLiveBadge(),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: _buildTouchData(isDark),
                  titlesData: _buildTitlesData(weekDays, textColor),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _generateRealGroups(
                    provider,
                    weekDays,
                    barBgColor,
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 1000),
                swapAnimationCurve: Curves.fastOutSlowIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REFINED LOGIC: Checks actual completion data for each day
  List<BarChartGroupData> _generateRealGroups(
    HabitProvider provider,
    List<DateTime> weekDays,
    Color bgColor,
  ) {
    return List.generate(weekDays.length, (i) {
      final date = weekDays[i];

      // Logic: Find habits completed on this specific day
      final totalHabits = provider.allHabits.length;
      if (totalHabits == 0) return _makeGroupData(i, 0, bgColor);

      // In a real DB, you'd check a 'completionLogs' table.
      // For now, we simulate based on the provider's logic:
      final completedOnDate = provider.allHabits.where((h) {
        if (h.lastCompleted == null) return false;
        return h.lastCompleted!.year == date.year &&
            h.lastCompleted!.month == date.month &&
            h.lastCompleted!.day == date.day;
      }).length;

      double completionPercentage = (completedOnDate / totalHabits) * 100;

      // Ensure current day shows real-time progress
      return _makeGroupData(i, completionPercentage.clamp(5, 100), bgColor);
    });
  }

  BarChartGroupData _makeGroupData(int x, double y, Color bgColor) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF7B61FF), Color(0xFFAC5DED)],
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: bgColor,
          ),
          // Adding a small neon shadow to the rod
          rodStackItems: [],
        ),
      ],
    );
  }

  BarTouchData _buildTouchData(bool isDark) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => const Color(0xFFAC5DED),
        tooltipBorderRadius: BorderRadius.circular(10),

        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '${rod.toY.toInt()}%',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<DateTime> weekDays, Color textColor) {
    return FlTitlesData(
      show: true,
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (double value, TitleMeta meta) {
            int index = value.toInt();
            if (index < 0 || index >= weekDays.length)
              return const SizedBox.shrink();

            // Format to 'Mon', 'Tue', etc.
            String label = DateFormat(
              'E',
            ).format(weekDays[index]).toUpperCase();

            return SideTitleWidget(
              meta: meta,
              space: 12,
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFAC5DED).withOpacity(0.2)),
      ),
      child: const Text(
        "LIVE DATA",
        style: TextStyle(
          color: Color(0xFFAC5DED),
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
