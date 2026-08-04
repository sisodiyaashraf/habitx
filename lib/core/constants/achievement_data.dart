import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/habit_provider.dart';
import 'achievement_constants.dart';

class AchievementData {
  static List<Map<String, dynamic>> getAchievementData(HabitProvider provider) {
    final habits = provider.allHabits;
    final int totalCompletions = habits.fold(0, (sum, h) => sum + h.completedDates.length);
    final int maxStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    final int userLevel = provider.userLevel;

    return [
      {
        "id": AchievementConstants.initiate,
        "icon": FontAwesomeIcons.rocket,
        "label": "Initiate",
        "unlocked": totalCompletions >= 1,
        "m": "1 Habit Completed",
        "desc": "Take the first step on your epic productivity journey by completing your first habit.",
        "color": const Color(0xFFAC5DED),
      },
      {
        "id": AchievementConstants.momentum,
        "icon": FontAwesomeIcons.fire,
        "label": "Momentum",
        "unlocked": maxStreak >= 3,
        "m": "3 Day Streak",
        "desc": "Stoke the fire. Maintain a streak of 3 days on any habit.",
        "color": const Color(0xFFFF5722),
      },
      {
        "id": AchievementConstants.focus,
        "icon": FontAwesomeIcons.brain,
        "label": "Deep Focus",
        "unlocked": maxStreak >= 7,
        "m": "7 Day Streak",
        "desc": "Lock it in. Complete any habit 7 days in a row.",
        "color": const Color(0xFF2196F3),
      },
      {
        "id": AchievementConstants.unstoppable,
        "icon": FontAwesomeIcons.bolt,
        "label": "Unstoppable",
        "unlocked": maxStreak >= 14,
        "m": "14 Day Streak",
        "desc": "Pure willpower. Maintain a 14-day streak on any habit.",
        "color": const Color(0xFFFFC107),
      },
      {
        "id": AchievementConstants.consistencyGuru,
        "icon": FontAwesomeIcons.infinity,
        "label": "Consistency Guru",
        "unlocked": maxStreak >= 30,
        "m": "30 Day Streak",
        "desc": "Habit mastery achieved! Run a streak for 30 consecutive days.",
        "color": const Color(0xFFE91E63),
      },
      {
        "id": AchievementConstants.guardian,
        "icon": FontAwesomeIcons.shieldHalved,
        "label": "Guardian",
        "unlocked": totalCompletions >= 50,
        "m": "50 Completed",
        "desc": "A protector of habits. Accumulate 50 habit completions over time.",
        "color": const Color(0xFF4CAF50),
      },
      {
        "id": AchievementConstants.centurion,
        "icon": FontAwesomeIcons.shield,
        "label": "Centurion",
        "unlocked": totalCompletions >= 100,
        "m": "100 Completed",
        "desc": "A legendary milestone. Accumulate 100 total habit completions.",
        "color": const Color(0xFF00BCD4),
      },
      {
        "id": AchievementConstants.diamond,
        "icon": FontAwesomeIcons.gem,
        "label": "Diamond",
        "unlocked": totalCompletions >= 250,
        "m": "250 Completed",
        "desc": "Solid as a diamond. Accumulate 250 total habit completions.",
        "color": const Color(0xFF9C27B0),
      },
      {
        "id": AchievementConstants.level10,
        "icon": FontAwesomeIcons.star,
        "label": "Decathlon",
        "unlocked": userLevel >= 10,
        "m": "Level 10 Reached",
        "desc": "Rise through the ranks. Reach Level 10 on your profile.",
        "color": const Color(0xFFFF9800),
      },
      {
        "id": AchievementConstants.eliteKing,
        "icon": FontAwesomeIcons.crown,
        "label": "Elite King",
        "unlocked": userLevel >= 25,
        "m": "Level 25 Reached",
        "desc": "True dominance. Reach Level 25 and rule the daily streaks.",
        "color": const Color(0xFFFFEB3B),
      },
      {
        "id": AchievementConstants.grandmaster,
        "icon": FontAwesomeIcons.trophy,
        "label": "Grandmaster",
        "unlocked": userLevel >= 50,
        "m": "Level 50 Reached",
        "desc": "A god amongst mortals. Reach the legendary Level 50.",
        "color": const Color(0xFFFF3D00),
      },
    ];
  }
}
