import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../domain/models/habit.dart';

class WeeklyPerformanceWidget extends StatelessWidget {
  final Color textColor;
  final Color subTextColor;
  final bool isDark;

  const WeeklyPerformanceWidget({
    super.key,
    required this.textColor,
    required this.subTextColor,
    required this.isDark,
  });

  bool _isDayActive(HabitProvider provider, DateTime date) {
    return provider.allHabits.any((h) => h.completedDates.any((d) => d.isSameDay(date)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final pastWeek = provider.pastWeekDates;
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.2),
          isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WEEKLY PERFORMANCE",
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
              children: List.generate(pastWeek.length, (index) {
                final date = pastWeek[index];
                final isActive = _isDayActive(provider, date);
                final dayLabel = weekdays[date.weekday - 1];
                final isToday = date.isSameDay(DateTime.now());

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
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                              )
                            : null,
                        color: isActive ? null : (isDark ? Colors.white12 : Colors.black12),
                        border: isToday
                            ? Border.all(
                                color: const Color(0xFF00E5FF),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Icon(
                        isActive ? Icons.check : Icons.close,
                        size: 12,
                        color: isActive ? Colors.white : (isDark ? Colors.white30 : Colors.black38),
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
