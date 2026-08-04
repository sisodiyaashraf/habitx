import '../../domain/models/habit.dart';

class StreakEngine {
  static bool needsFreezeReplenish(DateTime lastReset, DateTime now) {
    final daysToSubtract = (now.weekday - DateTime.monday) % 7;
    final thisMonday = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToSubtract));
    return lastReset.isBefore(thisMonday);
  }

  static bool canFreezeHabit(Habit habit) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final todayCompleted = habit.completedDates.any((d) => d.isSameDay(now)) || habit.isCompleted;
    final todayFrozen = habit.frozenDates.any((d) => d.isSameDay(now));
    
    final yesterdayIntact = habit.completedDates.any((d) => d.isSameDay(yesterday)) || 
                            habit.frozenDates.any((d) => d.isSameDay(yesterday));

    final hasFreezeAvailable = habit.streakFreezesAvailable > 0;

    return !todayCompleted && !todayFrozen && yesterdayIntact && hasFreezeAvailable;
  }

  static int calculateNewStreak({
    required Habit habit,
    required bool isNowCompleted,
    required DateTime now,
  }) {
    final yesterday = now.subtract(const Duration(days: 1));
    final bool yesterdayIntact = habit.completedDates.any((d) => d.isSameDay(yesterday)) ||
                                 habit.frozenDates.any((d) => d.isSameDay(yesterday));

    if (isNowCompleted) {
      if (yesterdayIntact || habit.streak == 0) {
        return habit.streak + 1;
      } else {
        return 1;
      }
    } else {
      return habit.streak > 0 ? habit.streak - 1 : 0;
    }
  }

  static Habit processDailyResetAndStreakDecay(Habit habit, DateTime now) {
    final yesterday = now.subtract(const Duration(days: 1));
    bool isDifferentDay = !habit.lastCompleted.isSameDay(now);
    Habit processed = habit;

    if (habit.isCompleted && isDifferentDay) {
      processed = processed.copyWith(isCompleted: false);
    }

    final wasCompletedYesterday = habit.completedDates.any((d) => d.isSameDay(yesterday));
    final wasFrozenYesterday = habit.frozenDates.any((d) => d.isSameDay(yesterday));

    if (isDifferentDay && !wasCompletedYesterday && !wasFrozenYesterday && processed.streak > 0) {
      processed = processed.copyWith(streak: 0);
    }

    return processed;
  }
}
