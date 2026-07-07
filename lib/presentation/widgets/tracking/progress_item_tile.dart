import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/models/habit.dart';

class ProgressItemTile extends StatelessWidget {
  final Habit habit;

  const ProgressItemTile({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final arrowColor = isDark ? Colors.white38 : Colors.black26;

    // Difficulty-based badge styling
    Color diffColor;
    String diffLabel;
    switch (habit.difficulty) {
      case HabitDifficulty.easy:
        diffColor = const Color(0xFF00E5FF);
        diffLabel = "EASY";
        break;
      case HabitDifficulty.medium:
        diffColor = const Color(0xFFFFB300);
        diffLabel = "MID";
        break;
      case HabitDifficulty.hard:
        diffColor = const Color(0xFFFF5252);
        diffLabel = "HARD";
        break;
    }

    // Progress towards 7-day completion targets
    final double streakProgress = (habit.streak / 7.0).clamp(0.05, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 100,
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.3),
            isDark ? Colors.black.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withValues(alpha: 0.4),
            Colors.white.withValues(alpha: 0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // High-Contrast Icon Container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: habit.isCompleted
                          ? const Color(0xFFAC5DED).withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: habit.isCompleted
                            ? const Color(0xFFAC5DED)
                            : Colors.white24,
                      ),
                    ),
                    child: Icon(
                      habit.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      color: habit.isCompleted
                          ? const Color(0xFFAC5DED)
                          : subTextColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Text Content using Onyx Hierarchy
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                habit.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Difficulty Chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: diffColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: diffColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                diffLabel,
                                style: TextStyle(
                                  color: diffColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fire,
                              color: habit.streak > 0 ? const Color(0xFFAC5DED) : subTextColor,
                              size: 11,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${habit.streak} DAY STREAK",
                              style: TextStyle(
                                color: habit.streak > 0 ? textColor : subTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "+${habit.xpValue} XP",
                              style: const TextStyle(
                                color: Color(0xFF00E5FF),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right-aligned status arrow
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: arrowColor,
                    size: 14,
                  ),
                ],
              ),

              // Streak Progression Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 4,
                  width: double.infinity,
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: streakProgress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFAC5DED),
                            Color(0xFF00E5FF),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
