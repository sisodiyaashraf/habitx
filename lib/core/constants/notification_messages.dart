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
    "HabitX Alert: Consistency is the only hack.",
    "Protocol 01: Execute your primary objective now.",
    "Shalcontech Intelligence: Data suggests you're due for a win.",
  ];

  /// Gen Z style prompts - more informal, trendy, and relatable.
  static const List<String> genZMessages = [
    "No cap, your streak is looking fire. Keep it up! 🔥",
    "Don't let your habits ghost you. Log them now! 💀",
    "Main character energy only. Finish your tasks! 💅",
    "Your future self is literally screaming. Do the work! 📢",
    "Sending positive vibes, but also... do your habits. ✨",
    "That habit is rent-free in your head. Just do it! 🧠",
    "Stop doomscrolling and start habit-rolling. 📱",
    "Lowkey, you're crushing it. Highkey, do one more. 📈",
    "Imagine not completing your habits... couldn't be you. 💅",
    "Giving: Productive King/Queen. Keep that energy! 👑",
    "The grind don't stop. Validated by HabitX. ✅",
    "Slay the day, one habit at a time. 🗡️",
    "Your potential is giving... infinite. Lock in. ♾️",
    "POV: You're actually reaching your goals. 📸",
    "Don't be mid. Be elite. Check your tasks. 💯",
    "Big brain moves only. Log your progress. 🧠",
    "Respect the hustle. Your streak is iconic. 🛐",
    "It's a marathon, not a sprint. Keep that aesthetic. 🏃‍♂️",
    "No zero days, fr fr. 😤",
    "Vibe check: Are you winning yet? 🤙",
  ];

  /// Helper to get a random motivational prompt based on persona
  static String getRandomPrompt(String persona) {
    final List<String> messages =
        persona.toLowerCase() == 'genz' ? genZMessages : eliteMessages;
    return messages[DateTime.now().microsecondsSinceEpoch % messages.length];
  }
}
