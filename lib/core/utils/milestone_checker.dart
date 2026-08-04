import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/achievement_constants.dart';
import '../../domain/models/habit.dart';

class MilestoneChecker {
  static void checkMilestones({
    required List<Habit> allHabits,
    required int userLevel,
    required List<String> unlockedAchievementIds,
    required void Function(String id, String title, dynamic icon, int xpReward) onUnlock,
  }) {
    final int totalCompletions = allHabits.fold(0, (sum, h) => sum + h.completedDates.length);
    final int maxStreak = allHabits.isEmpty
        ? 0
        : allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    if (totalCompletions >= 1) {
      onUnlock(
        AchievementConstants.initiate,
        "INITIATE",
        FontAwesomeIcons.rocket,
        100,
      );
    }
    if (maxStreak >= 3) {
      onUnlock(
        AchievementConstants.momentum,
        "MOMENTUM",
        FontAwesomeIcons.fire,
        150,
      );
    }
    if (maxStreak >= 7) {
      onUnlock(
        AchievementConstants.focus,
        "DEEP FOCUS",
        FontAwesomeIcons.brain,
        300,
      );
    }
    if (maxStreak >= 14) {
      onUnlock(
        AchievementConstants.unstoppable,
        "UNSTOPPABLE",
        FontAwesomeIcons.bolt,
        500,
      );
    }
    if (maxStreak >= 30) {
      onUnlock(
        AchievementConstants.consistencyGuru,
        "CONSISTENCY GURU",
        FontAwesomeIcons.infinity,
        1000,
      );
    }
    if (totalCompletions >= 50) {
      onUnlock(
        AchievementConstants.guardian,
        "GUARDIAN",
        FontAwesomeIcons.shieldHalved,
        500,
      );
    }
    if (totalCompletions >= 100) {
      onUnlock(
        AchievementConstants.centurion,
        "CENTURION",
        FontAwesomeIcons.shield,
        1000,
      );
    }
    if (totalCompletions >= 250) {
      onUnlock(
        AchievementConstants.diamond,
        "DIAMOND",
        FontAwesomeIcons.gem,
        2000,
      );
    }
    if (userLevel >= 10) {
      onUnlock(
        AchievementConstants.level10,
        "DECATHLON",
        FontAwesomeIcons.star,
        500,
      );
    }
    if (userLevel >= 25) {
      onUnlock(
        AchievementConstants.eliteKing,
        "ELITE KING",
        FontAwesomeIcons.crown,
        1500,
      );
    }
    if (userLevel >= 50) {
      onUnlock(
        AchievementConstants.grandmaster,
        "GRANDMASTER",
        FontAwesomeIcons.trophy,
        3000,
      );
    }
  }
}
