class NotificationMessages {
  /// Professional coaching prompts for daily habit reinforcement.
  static const List<String> eliteMessages = [
    "System Check: Are you winning the day?",
    "Discipline equals freedom. Review your dashboard.",
    "Small daily steps build empires. Don't break your streak.",
    "Elite focus required. Execute your goals.",
    "Your potential is defined by your consistency.",
    "Momentum is built in the shadows. Keep working.",
    "Sharpen the axe. Dedicate 10 minutes to focus.",
    "Data doesn't lie. Keep your completion rate high.",
    "No zero days. Move the needle now.",
    "Architect your future. Check off today's habits.",
    "The version of you next year depends on today's choices.",
    "Stay locked in. Review your pending tasks.",
    "Win the morning, win the day. Start your first habit.",
    "Progress over perfection. Just get started.",
    "Be the outlier. Consistency is your competitive edge.",
    "Focus is a muscle. Give it a workout right now.",
    "Don't wish for it. Work for it.",
    "Standardize before you optimize. Log your progress.",
    "Excellence is a habit, not an act. Stay sharp.",
    "Master your habits, master your life.",
    "Motivation gets you started. Habit keeps you going.",
    "Don't stop when you're tired. Stop when you're done.",
    "High intensity, high reward. Execute your mission.",
    "Greatness is found in the grind. Keep pushing.",
    "Deep work protocol: Engage now.",
    "Every checkmark is a step toward elite status.",
    // Added for HabitX branding
    "HabitX Alert: Consistency is the only hack.",
    "Protocol 01: Execute your primary objective now.",
    "Shalcontech Intelligence: Data suggests you're due for a win.",
  ];

  /// Helper to get a random motivational prompt
  static String get randomCoachPrompt {
    return eliteMessages[DateTime.now().millisecond % eliteMessages.length];
  }
}
