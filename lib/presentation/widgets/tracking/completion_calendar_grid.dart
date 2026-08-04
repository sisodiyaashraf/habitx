import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../domain/models/habit.dart';

class CompletionCalendarGrid extends StatelessWidget {
  final Habit habit;
  final Color textColor;
  final Color subTextColor;
  final bool isDark;

  const CompletionCalendarGrid({
    super.key,
    required this.habit,
    required this.textColor,
    required this.subTextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return GlassmorphicContainer(
      width: double.infinity,
      height: 110,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.0,
      linearGradient: LinearGradient(
        colors: [
          isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "COMPLETION HISTORY",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "Last 7 Days",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(last7Days.length, (index) {
                final date = last7Days[index];
                final isCompletedOnDay = habit.completedDates.any(
                  (d) => d.year == date.year && d.month == date.month && d.day == date.day
                ) || (date.year == now.year && date.month == now.month && date.day == now.day && habit.isCompleted);

                final isFrozenOnDay = habit.frozenDates.any(
                  (d) => d.year == date.year && d.month == date.month && d.day == date.day
                );

                final dayLabel = weekdays[date.weekday - 1];
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

                return Column(
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        color: isToday ? const Color(0xFFAC5DED) : subTextColor,
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isCompletedOnDay
                            ? const LinearGradient(
                                colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                              )
                            : (isFrozenOnDay
                                ? const LinearGradient(
                                    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                                  )
                                : null),
                        color: (isCompletedOnDay || isFrozenOnDay) ? null : (isDark ? Colors.white12 : Colors.black12),
                        border: isToday
                            ? Border.all(
                                color: const Color(0xFF00E5FF),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: isCompletedOnDay
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : (isFrozenOnDay
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : []),
                      ),
                      child: Icon(
                        isCompletedOnDay
                            ? Icons.check
                            : (isFrozenOnDay ? Icons.ac_unit_rounded : Icons.close),
                        size: 12,
                        color: (isCompletedOnDay || isFrozenOnDay) ? Colors.white : (isDark ? Colors.white30 : Colors.black38),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
