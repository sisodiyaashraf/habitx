import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../providers/habit_provider.dart';

class QuickStatsRow extends StatelessWidget {
  final HabitProvider provider;
  final Color textColor;
  final Color subTextColor;
  final bool isDark;

  const QuickStatsRow({
    super.key,
    required this.provider,
    required this.textColor,
    required this.subTextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final int done = provider.allHabits.where((h) => h.isCompleted).length;
    final int total = provider.allHabits.length;
    final int maxStreak = provider.allHabits.isEmpty
        ? 0
        : provider.allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statBox(
          "XP",
          "${provider.userXP}",
          FontAwesomeIcons.bolt,
        ),
        _statBox(
          "STREAK",
          "$maxStreak",
          FontAwesomeIcons.fire,
        ),
        _statBox(
          "DONE",
          "$done/$total",
          FontAwesomeIcons.checkDouble,
        ),
      ],
    );
  }

  Widget _statBox(
    String label,
    String value,
    dynamic icon,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
