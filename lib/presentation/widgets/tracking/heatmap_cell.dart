import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A single tappable heatmap cell showing a date and activity level.
class HeatmapCell extends StatelessWidget {
  final DateTime date;
  final num value;
  final bool isSelected;
  final bool isDark;
  final void Function(DateTime, num) onSelected;
  final bool showDayLabel;
  final double? fontSize;

  const HeatmapCell({
    super.key,
    required this.date,
    required this.value,
    required this.isSelected,
    required this.isDark,
    required this.onSelected,
    this.showDayLabel = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = DateTime(date.year, date.month, date.day);
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onSelected(normalized, value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: getCellDecoration(value, isDark, isSelected),
        child: showDayLabel
            ? Column(
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
              )
            : Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: fontSize ?? 12,
                    fontWeight: FontWeight.w900,
                    color: value > 0
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
              ),
      ),
    );
  }
}

BoxDecoration getCellDecoration(num value, bool isDark, bool isSelected) {
  final border = isSelected ? Border.all(color: Colors.white, width: 2) : null;

  if (value == 0) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.03),
      border: border ??
          Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
    );
  }

  const gradients = {
    1: [Color(0xFF00E676), Color(0xFF00B0FF)],
    2: [Color(0xFFAC5DED), Color(0xFF00E5FF)],
    3: [Color(0xFF7B61FF), Color(0xFFFF2A85)],
  };
  const glows = {
    1: Color(0xFF00E676),
    2: Color(0xFFAC5DED),
    3: Color(0xFFFF2A85),
  };
  const glowAlphas = {1: 0.30, 2: 0.35, 3: 0.40};

  final colors = gradients[value] ?? [const Color(0xFFFF9100), const Color(0xFFFF3D00)];
  final glow = glows[value] ?? const Color(0xFFFF3D00);
  final alpha = glowAlphas[value] ?? 0.50;

  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: border,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    ),
    boxShadow: [
      BoxShadow(color: glow.withValues(alpha: alpha), blurRadius: 6, spreadRadius: 1),
    ],
  );
}
