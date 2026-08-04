import '../../domain/models/habit.dart';

class HeatmapDataGenerator {
  static Map<DateTime, num> generateRealDataMap(
    List<Habit> habits,
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

    for (var habit in habits) {
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

      if (habit.isCompleted) {
        final lastCompDate = DateTime(
          habit.lastCompleted.year,
          habit.lastCompleted.month,
          habit.lastCompleted.day,
        );
        if (heatmapData.containsKey(lastCompDate)) {
          bool alreadyCounted = habit.completedDates.any(
            (d) => d.isSameDay(lastCompDate),
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
