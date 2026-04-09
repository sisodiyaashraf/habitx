import 'dart:math';
import '../../providers/habit_provider.dart';

class AiBotService {
  // --- TACTICAL DATA SETS ---

  final List<String> _emergencyProtocols = [
    "Critical inertia detected. Execute a 'Rapid Strike' mission now to break the cycle.",
    "Your current performance metrics are sub-optimal. One micro-win will reset the neural trend.",
    "Data shows a focus deficit. Stop overthinking; start executing. Protocol: Just Start.",
  ];

  final List<String> _eliteMomentum = [
    "Streak stability: EXCELLENT. You are currently operating at an elite frequency.",
    "Momentum is your greatest asset right now. Don't let the rhythm break.",
    "Neural pathways for your habits are hardening. Consistency is your competitive edge.",
  ];

  final List<String> _noDataFound = [
    "System standby. No active mission protocols found. Awaiting habit initialization, Ashraf.",
    "The HabitX engine is idle. Input your primary objectives to begin tracking.",
  ];

  final List<String> _midDayCheck = [
    "Mid-day audit: %completed% objectives secured. The mission is still live.",
    "Standardizing excellence takes 24 hours at a time. Review your remaining tasks.",
    "Focus is a resource. Refill yours by checking off one pending protocol.",
  ];

  /// Returns a context-aware tactical briefing based on deep data analysis
  String getDailyMotivation(HabitProvider provider) {
    final habits = provider.allHabits;
    final random = Random();

    // 1. VOID STATE: No habits
    if (habits.isEmpty) {
      return _noDataFound[random.nextInt(_noDataFound.length)];
    }

    // 2. PERFORMANCE METRICS
    final int total = habits.length;
    final int completed = habits.where((h) => h.isCompleted).length;
    final int remaining = total - completed;
    final double completionRate = completed / total;

    // 3. STREAK HEALTH
    final int maxStreak = habits.map((h) => h.streak).fold(0, max);
    final bool highMomentum = maxStreak >= 5;

    // --- HEURISTIC LOGIC ENGINE ---

    // Priority 1: High Completion (Success State)
    if (completionRate == 1.0) {
      return "Objective Secured. All $total protocols executed today. Streak: $maxStreak. You are winning the day.";
    }

    // Priority 2: Critical Low Activity (The "Nudge")
    if (completionRate < 0.3 && total >= 3) {
      return _emergencyProtocols[random.nextInt(_emergencyProtocols.length)];
    }

    // Priority 3: Elite Maintenance
    if (highMomentum) {
      return _eliteMomentum[random.nextInt(_eliteMomentum.length)];
    }

    // Priority 4: Mid-Process Briefing (Dynamic interpolation)
    String midDayMsg = _midDayCheck[random.nextInt(_midDayCheck.length)];
    return midDayMsg.replaceAll("%completed%", "$completed/$total");
  }

  /// NEW: Offline Logic to suggest specific features based on progress
  /// This can be used to populate the "Strategic Options" in the UI
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
        }, // Icons.add_circle
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
      }, // Icons.analytics
    ];
  }
}
