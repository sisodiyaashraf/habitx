import 'dart:math';
import '../../providers/habit_provider.dart';
import '../../core/constants/notification_messages.dart';

class AiBotService {
  /// Returns a context-aware tactical briefing based on deep data analysis and Shelby active mood.
  String getDailyMotivation(HabitProvider provider) {
    final habits = provider.allHabits;

    // 1. VOID STATE: No habits
    if (habits.isEmpty) {
      return NotificationMessages.getInAppBriefing(
        persona: provider.activePersona,
        context: 'empty',
        username: provider.userName,
      );
    }

    final int total = habits.length;
    final int completed = habits.where((h) => h.isCompleted).length;
    final double completionRate = completed / total;
    final int maxStreak = habits.map((h) => h.streak).fold(0, max);

    String contextType = 'midday';
    if (completionRate == 1.0) {
      contextType = 'celebration';
    } else if (completionRate < 0.3) {
      contextType = 'nudge';
    } else if (maxStreak >= 5) {
      contextType = 'momentum';
    }

    return NotificationMessages.getInAppBriefing(
      persona: provider.activePersona,
      context: contextType,
      username: provider.userName,
      completed: completed,
      total: total,
      streak: maxStreak,
    );
  }

  /// Suggests specific focus timers or routes based on daily completion rates
  List<Map<String, dynamic>> getTacticalSuggestions(HabitProvider provider) {
    final habits = provider.allHabits;
    final completed = habits.where((h) => h.isCompleted).length;
    final progress = habits.isEmpty ? 0.0 : completed / habits.length;

    if (habits.isEmpty) {
      return [
        {
          "type": "nav",
          "label": "INITIALIZE HABIT",
          "icon": 0xe109,
        },
      ];
    }

    if (progress < 0.5) {
      return [
        {"type": "timer", "label": "45M FOCUS LOCK", "value": 45},
        {"type": "timer", "label": "15M SPRINT", "value": 15},
      ];
    }

    return [
      {"type": "timer", "label": "25M POMODORO", "value": 25},
      {
        "type": "nav",
        "label": "VIEW PROGRESS",
        "icon": 0xe0a2,
      },
    ];
  }
}
