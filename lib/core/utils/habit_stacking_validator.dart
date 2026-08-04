import '../../domain/models/habit.dart';

class HabitStackingValidator {
  static bool isCircularChain({
    required String startId,
    required String? triggerId,
    required List<Habit> allHabits,
  }) {
    if (triggerId == null) return false;
    if (startId == triggerId) return true;

    String? currentId = triggerId;
    final visited = {startId};

    while (currentId != null) {
      if (!visited.add(currentId)) {
        return true;
      }
      Habit? next;
      for (final h in allHabits) {
        if (h.id == currentId) {
          next = h;
          break;
        }
      }
      if (next == null) break;
      currentId = next.triggerHabitId;
    }
    return false;
  }
}
