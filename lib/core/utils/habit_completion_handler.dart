import '../../domain/models/habit.dart';
import 'streak_engine.dart';
import 'xp_level_calculator.dart';

class HabitCompletionResult {
  final List<Habit> updatedHabits;
  final Habit updatedHabit;
  final int newXP;
  final int newLevel;
  final bool isNowCompleted;
  final int xpDifference;

  HabitCompletionResult({
    required this.updatedHabits,
    required this.updatedHabit,
    required this.newXP,
    required this.newLevel,
    required this.isNowCompleted,
    required this.xpDifference,
  });
}

class HabitCompletionHandler {
  static HabitCompletionResult toggleCompletion({
    required List<Habit> allHabits,
    required String habitId,
    required int currentXP,
    required int currentLevel,
    required DateTime now,
  }) {
    final index = allHabits.indexWhere((h) => h.id == habitId);
    if (index == -1) {
      throw Exception("Habit not found");
    }

    final habit = allHabits[index];
    final bool isNowCompleted = !habit.isCompleted;
    final List<DateTime> updatedCompletedDates = List.from(habit.completedDates);

    int newStreak = StreakEngine.calculateNewStreak(
      habit: habit,
      isNowCompleted: isNowCompleted,
      now: now,
    );

    int xpDifference = habit.xpValue;
    int newXP = currentXP;
    if (isNowCompleted) {
      newXP += xpDifference;
      bool alreadyAdded = updatedCompletedDates.any((d) => d.isSameDay(now));
      if (!alreadyAdded) {
        updatedCompletedDates.add(now);
      }
    } else {
      newXP = (newXP - xpDifference).clamp(0, 1000000);
      updatedCompletedDates.removeWhere((d) => d.isSameDay(now));
    }

    int newLevel = XpLevelCalculator.calculateNewLevel(newXP, currentLevel);

    final updatedHabit = habit.copyWith(
      isCompleted: isNowCompleted,
      streak: newStreak,
      lastCompleted: now,
      completedDates: updatedCompletedDates,
    );

    final updatedHabits = List<Habit>.from(allHabits);
    updatedHabits[index] = updatedHabit;

    return HabitCompletionResult(
      updatedHabits: updatedHabits,
      updatedHabit: updatedHabit,
      newXP: newXP,
      newLevel: newLevel,
      isNowCompleted: isNowCompleted,
      xpDifference: xpDifference,
    );
  }
}
