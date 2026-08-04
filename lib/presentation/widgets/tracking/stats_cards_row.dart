import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../domain/models/habit.dart';

class StatsCardsRow extends StatelessWidget {
  final Habit habit;
  final bool isDark;
  final Color textColor;

  const StatsCardsRow({
    super.key,
    required this.habit,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSmallStatCard(
          "STREAK",
          "${habit.streak} Days",
          FontAwesomeIcons.fire,
          isDark,
          textColor,
        ),
        const SizedBox(width: 10),
        _buildSmallStatCard(
          "REWARD",
          "+${habit.xpValue} XP",
          FontAwesomeIcons.bolt,
          isDark,
          textColor,
        ),
        const SizedBox(width: 10),
        _buildSmallStatCard(
          "TIMER",
          "${habit.timerDuration} Min",
          FontAwesomeIcons.clock,
          isDark,
          textColor,
        ),
      ],
    );
  }

  Widget _buildSmallStatCard(
    String label,
    String value,
    dynamic icon,
    bool isDark,
    Color textColor,
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 90,
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            isDark ? Colors.white10 : Colors.white24,
            Colors.transparent,
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: const Color(0xFF00E5FF), size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
