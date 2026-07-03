import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../providers/habit_provider.dart';

class EliteHeatmap extends StatefulWidget {
  const EliteHeatmap({super.key});

  @override
  State<EliteHeatmap> createState() => _EliteHeatmapState();
}

class _EliteHeatmapState extends State<EliteHeatmap> {
  int _selectedDays = 30;
  DateTime? _selectedCellDate;
  num _selectedCellIntensity = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Responsive height for rich content layout with filters
    const double containerHeight = 510.0;

    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(
      Duration(days: _selectedDays - 1),
    );

    final dataMap = _generateRealDataMap(provider, startDate, endDate);
    final activeDaysCount = dataMap.values.where((v) => v > 0).length;

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
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.25),
          isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withValues(alpha: 0.6),
          const Color(0xFF00E5FF).withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.fireFlameCurved,
                        color: Color(0xFFAC5DED),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_selectedDays-DAY INTENSITY",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "NEURAL ACTIVITY MATRIX",
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildBadge("ELITE TRACKER", isDark),
              ],
            ),

            const SizedBox(height: 12),

            // --- Timeframe Filter Options (7D, 30D, 60D, 90D) ---
            _buildTimeframeSelector(isDark),

            const SizedBox(height: 16),

            // --- Quick Stats Banner ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    "ACTIVE DAYS",
                    "$activeDaysCount / $_selectedDays",
                    isDark,
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                  _buildStatItem(
                    "CONSISTENCY",
                    "${((activeDaysCount / _selectedDays) * 100).toStringAsFixed(0)}%",
                    isDark,
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                  _buildStatItem(
                    "STATUS",
                    activeDaysCount > (_selectedDays * 0.6)
                        ? "PRIME 🔥"
                        : "OPTIMAL ⚡",
                    isDark,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _selectedDays == 7
                    ? _build7DayGridView(dataMap, startDate, endDate, isDark)
                    : _buildMultiDayGridView(
                        dataMap,
                        startDate,
                        endDate,
                        isDark,
                        _selectedDays,
                      ),
              ),
            ),

            const SizedBox(height: 6),

            // --- Footer: Selected Date Detail or Legend ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedCellDate != null
                  ? _buildCellDetailBar(isDark)
                  : _buildMultiTierLegend(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black45,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeSelector(bool isDark) {
    final options = [7, 30, 60, 90];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.map((days) {
        bool isSelected = _selectedDays == days;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedDays = days;
              _selectedCellDate = null;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFAC5DED)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFAC5DED)
                    : Colors.transparent,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              "${days}D",
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.black54),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _build7DayGridView(
    Map<DateTime, num> dataMap,
    DateTime startDate,
    DateTime endDate,
    bool isDark,
  ) {
    final daysList = List.generate(7, (index) {
      return startDate.add(Duration(days: index));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.3,
        ),
        itemCount: daysList.length,
        itemBuilder: (context, index) {
          final date = daysList[index];
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final value = dataMap[normalizedDate] ?? 0;
          final isSelected =
              _selectedCellDate != null &&
              _selectedCellDate!.year == date.year &&
              _selectedCellDate!.month == date.month &&
              _selectedCellDate!.day == date.day;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedCellDate = normalizedDate;
                _selectedCellIntensity = value;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: _getCellDecoration(value, isDark, isSelected),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: value > 0
                          ? Colors.white70
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: value > 0
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMultiDayGridView(
    Map<DateTime, num> dataMap,
    DateTime startDate,
    DateTime endDate,
    bool isDark,
    int daysCount,
  ) {
    final daysList = List.generate(daysCount, (index) {
      return startDate.add(Duration(days: index));
    });

    final weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    const int crossAxisCount = 7;

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weekday Header Bar (SUN to SAT)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekdays.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: daysCount > 60 ? 6 : 8,
                mainAxisSpacing: daysCount > 60 ? 6 : 8,
                childAspectRatio: 1.0,
              ),
              itemCount: daysList.length,
              itemBuilder: (context, index) {
                final date = daysList[index];
                final normalizedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                );
                final value = dataMap[normalizedDate] ?? 0;
                final isSelected =
                    _selectedCellDate != null &&
                    _selectedCellDate!.year == date.year &&
                    _selectedCellDate!.month == date.month &&
                    _selectedCellDate!.day == date.day;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedCellDate = normalizedDate;
                      _selectedCellIntensity = value;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    decoration: _getCellDecoration(value, isDark, isSelected),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: daysCount > 60 ? 10 : 12,
                          fontWeight: FontWeight.w900,
                          color: value > 0
                              ? Colors.white
                              : (isDark ? Colors.white38 : Colors.black38),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getCellDecoration(num value, bool isDark, bool isSelected) {
    Border? border = isSelected
        ? Border.all(color: Colors.white, width: 2)
        : null;

    if (value == 0) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        border:
            border ??
            Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
      );
    } else if (value == 1) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: border,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withValues(alpha: 0.3),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      );
    } else if (value == 2) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: border,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFAC5DED), Color(0xFF00E5FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withValues(alpha: 0.35),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      );
    } else if (value == 3) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: border,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B61FF), Color(0xFFFF2A85)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2A85).withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: border,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9100), Color(0xFFFF3D00)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00).withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1.5,
          ),
        ],
      );
    }
  }

  Widget _buildBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withValues(alpha: 0.2),
            const Color(0xFF7B61FF).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFAC5DED),
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMultiTierLegend(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "INTENSITY SCALE",
          style: TextStyle(
            color: isDark ? Colors.white30 : Colors.black38,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        Row(
          children: [
            Text(
              "Less ",
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildLegendBox(
              isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            const SizedBox(width: 4),
            _buildLegendGradientBox(const [
              Color(0xFF00E676),
              Color(0xFF00B0FF),
            ]),
            const SizedBox(width: 4),
            _buildLegendGradientBox(const [
              Color(0xFFAC5DED),
              Color(0xFF00E5FF),
            ]),
            const SizedBox(width: 4),
            _buildLegendGradientBox(const [
              Color(0xFF7B61FF),
              Color(0xFFFF2A85),
            ]),
            const SizedBox(width: 4),
            _buildLegendGradientBox(const [
              Color(0xFFFF9100),
              Color(0xFFFF3D00),
            ]),
            Text(
              " More",
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildLegendGradientBox(List<Color> colors) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: LinearGradient(colors: colors),
      ),
    );
  }

  Widget _buildCellDetailBar(bool isDark) {
    final formattedDate = DateFormat(
      'EEE, MMM d, yyyy',
    ).format(_selectedCellDate!);
    String intensityText = "No Activity";
    Color accentColor = isDark ? Colors.white54 : Colors.black54;

    if (_selectedCellIntensity == 1) {
      intensityText = "1 Habit Completed (Light)";
      accentColor = const Color(0xFF00E676);
    } else if (_selectedCellIntensity == 2) {
      intensityText = "2 Habits Completed (Moderate)";
      accentColor = const Color(0xFFAC5DED);
    } else if (_selectedCellIntensity == 3) {
      intensityText = "3 Habits Completed (High)";
      accentColor = const Color(0xFFFF2A85);
    } else if (_selectedCellIntensity >= 4) {
      intensityText =
          "$_selectedCellIntensity Habits Completed (Peak Flame 🔥)";
      accentColor = const Color(0xFFFF9100);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: accentColor,
                ),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "• $intensityText",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => setState(() => _selectedCellDate = null),
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, num> _generateRealDataMap(
    HabitProvider provider,
    DateTime start,
    DateTime end,
  ) {
    Map<DateTime, num> heatmapData = {};
    DateTime current = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);

    while (current.isBefore(normalizedEnd) ||
        current.isAtSameMomentAs(normalizedEnd)) {
      heatmapData[current] = 0;
      current = current.add(const Duration(days: 1));
    }

    for (var habit in provider.allHabits) {
      // 1. Process historical completed dates stored for this habit
      for (var compDate in habit.completedDates) {
        final normalized = DateTime(
          compDate.year,
          compDate.month,
          compDate.day,
        );
        if (heatmapData.containsKey(normalized)) {
          heatmapData[normalized] = (heatmapData[normalized] ?? 0) + 1;
        }
      }

      // 2. Fallback for habits completed on lastCompleted date if completedDates array was empty
      if (habit.isCompleted) {
        final lastCompDate = DateTime(
          habit.lastCompleted.year,
          habit.lastCompleted.month,
          habit.lastCompleted.day,
        );
        if (heatmapData.containsKey(lastCompDate)) {
          bool alreadyCounted = habit.completedDates.any(
            (d) =>
                d.year == lastCompDate.year &&
                d.month == lastCompDate.month &&
                d.day == lastCompDate.day,
          );
          if (!alreadyCounted) {
            heatmapData[lastCompDate] = (heatmapData[lastCompDate] ?? 0) + 1;
          }
        }
      }
    }

    return heatmapData;
  }
}
