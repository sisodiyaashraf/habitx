import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_heatmap_calendar/simple_heatmap_calendar.dart';
import '../../../providers/habit_provider.dart';

class EliteHeatmap extends StatelessWidget {
  const EliteHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fixed Height for a perfect 5-row month grid
    const double containerHeight = 405.0;

    final DateTime endDate = DateTime.now();
    // 34 days back + 1 (today) = 35 days (Exactly 5 rows of 7 columns)
    final DateTime startDate = endDate.subtract(const Duration(days: 45));

    final dataMap = _generateRealDataMap(provider, startDate, endDate);

    final labelStyle = TextStyle(
      color: isDark ? Colors.white70 : Colors.black54,
      fontSize: 13,
      fontWeight: FontWeight.w900,
    );

    return GlassmorphicContainer(
      width: double.infinity,
      height: containerHeight,
      borderRadius: 30,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.2),
          isDark
              ? Colors.white.withOpacity(0.03)
              : Colors.white.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [const Color(0xFFAC5DED).withOpacity(0.5), Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Header Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.calendarCheck,
                      color: Color(0xFFAC5DED),
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "45-DAY INTENSITY",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                _buildBadge("ELITE TRACKER", isDark),
              ],
            ),
            const SizedBox(height: 24),

            // --- Heatmap Grid ---
            Expanded(
              child: Center(
                child: HeatmapCalendar<num>(
                  startDate: startDate,
                  endedDate: endDate,
                  selectedMap: dataMap,
                  // Logic for fallback colors (used for default rendering)
                  colorMap: <num, Color>{
                    1: Colors.greenAccent.withOpacity(0.3),
                    2: Colors.greenAccent.withOpacity(0.6),
                    3: Colors.greenAccent.withOpacity(0.85),
                    4: Colors.greenAccent,
                  },
                  cellSize: const Size(36.0, 36.0),
                  cellSpaceBetween: 7.0,

                  // Month Label Builder
                  monthLabelItemBuilder: (context, date, defaultText) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(defaultText.toUpperCase(), style: labelStyle),
                    );
                  },

                  // Week Label Builder (Mon, Wed, Fri)
                  weekLabelValueBuilder: (context, weekday, defaultText) {
                    if (defaultText == 'Mon' ||
                        defaultText == 'Wed' ||
                        defaultText == 'Fri') {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(defaultText, style: labelStyle),
                      );
                    }
                    return const SizedBox(width: 35);
                  },

                  style: const HeatmapCalendarStyle.defaults(
                    cellRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),

                  cellBuilder:
                      (context, childBuilder, columnIndex, rowIndex, date) {
                        final normalizedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        final value = dataMap[normalizedDate] ?? 0;

                        return GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // --- THE GRADIENT ENGINE ---
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // If value > 0, show linear gradient. Else, show empty box.
                                  gradient: value > 0
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.greenAccent.shade400,
                                            const Color(
                                              0xFF00C853,
                                            ).withOpacity(0.8),
                                          ],
                                        )
                                      : null,
                                  color: value == 0
                                      ? (isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.black.withOpacity(0.03))
                                      : null,
                                ),
                              ),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: value > 0
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white30
                                            : Colors.black26),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                ),
              ),
            ),

            const SizedBox(height: 10),
            _buildLegend(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFAC5DED),
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Inactive ",
          style: TextStyle(
            color: isDark ? Colors.white30 : Colors.black26,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.green.shade900],
            ),
          ),
        ),
        Text(
          " Active",
          style: TextStyle(
            color: isDark ? Colors.white30 : Colors.black26,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Map<DateTime, num> _generateRealDataMap(
    HabitProvider provider,
    DateTime start,
    DateTime end,
  ) {
    Map<DateTime, num> heatmapData = {};
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final normalizedDate = DateTime(current.year, current.month, current.day);
      heatmapData[normalizedDate] = 0;
      current = current.add(const Duration(days: 1));
    }
    for (var habit in provider.allHabits) {
      if (habit.lastCompleted != null && habit.isCompleted) {
        final compDate = DateTime(
          habit.lastCompleted!.year,
          habit.lastCompleted!.month,
          habit.lastCompleted!.day,
        );
        if (heatmapData.containsKey(compDate)) {
          heatmapData[compDate] = (heatmapData[compDate] ?? 0) + 1;
        }
      }
    }
    Map<DateTime, num> finalScaleMap = {};
    heatmapData.forEach((date, count) {
      if (count > 0) finalScaleMap[date] = 1;
    });
    return finalScaleMap;
  }
}
