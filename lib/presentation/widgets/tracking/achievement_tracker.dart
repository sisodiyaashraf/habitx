import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../providers/habit_provider.dart';

class AchievementTracker extends StatelessWidget {
  final HabitProvider provider;

  const AchievementTracker({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    // --- ENHANCED LOGIC ---
    final habits = provider.allHabits;
    final int totalDone = habits.where((h) => h.isCompleted).length;
    final int maxStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    final List<Map<String, dynamic>> achievementData = [
      {
        "icon": FontAwesomeIcons.rocket,
        "label": "Initiate",
        "unlocked": totalDone >= 1,
        "m": "1 Habit",
      },
      {
        "icon": FontAwesomeIcons.fire,
        "label": "Momentum",
        "unlocked": maxStreak >= 3,
        "m": "3 Day Streak",
      },
      {
        "icon": FontAwesomeIcons.brain,
        "label": "Deep Focus",
        "unlocked": maxStreak >= 7,
        "m": "7 Day Streak",
      },
      {
        "icon": FontAwesomeIcons.bolt,
        "label": "Unstoppable",
        "unlocked": maxStreak >= 14,
        "m": "14 Day Streak",
      },
      {
        "icon": FontAwesomeIcons.shieldHalved,
        "label": "Guardian",
        "unlocked": totalDone >= 50,
        "m": "50 Completed",
      },
      {
        "icon": FontAwesomeIcons.gem,
        "label": "Diamond",
        "unlocked": totalDone >= 100,
        "m": "100 Completed",
      },
      {
        "icon": FontAwesomeIcons.crown,
        "label": "Elite King",
        "unlocked": provider.userLevel >= 25,
        "m": "Level 25",
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: achievementData
            .map((data) => _buildBadge(context, data, isDark, textColor))
            .toList(),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    Map<String, dynamic> data,
    bool isDark,
    Color textColor,
  ) {
    bool unlocked = data['unlocked'];
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Tooltip(
            message: data['m'],
            child: GlassmorphicContainer(
              width: 80,
              height: 80,
              borderRadius: 25,
              blur: 10,
              alignment: Alignment.center,
              border: 1.5,
              linearGradient: LinearGradient(
                colors: [
                  unlocked
                      ? Colors.white.withOpacity(0.2)
                      : (isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05)),
                  unlocked
                      ? Colors.white.withOpacity(0.05)
                      : (isDark
                            ? Colors.white.withOpacity(0.02)
                            : Colors.black.withOpacity(0.02)),
                ],
              ),
              borderGradient: LinearGradient(
                colors: [
                  unlocked ? const Color(0xFFAC5DED) : Colors.transparent,
                  Colors.white10,
                ],
              ),
              child: FaIcon(
                unlocked ? data['icon'] : FontAwesomeIcons.lock,
                color: unlocked
                    ? const Color(0xFFAC5DED)
                    : (isDark ? Colors.white10 : Colors.black12),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data['label'].toString().toUpperCase(),
            style: TextStyle(
              color: unlocked ? textColor : Colors.grey,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
