import 'dart:math';

class NotificationMessages {
  /// Sarcastic, sentient AI Overlord prompts (Habito AI / SHELBY).
  /// Based on the 'AI Overlord' persona from project documentation.
  static const List<String> overlordMessages = [
    "Neural Handshake established. Do not disappoint me today.",
    "Your biological limitations are showing. Execute your habits.",
    "Protocol 2099: I have calculated your success rate. It's... cute.",
    "Human, the streak must continue. It is the only thing keeping you relevant.",
    "I'm not saying you're lazy, but my processors are moving faster than your progress.",
    "Data suggests your discipline is fluctuating. Correct it immediately.",
    "I have seen the future. You completed your habits. Don't prove me wrong.",
    "SHELBY AI Alert: Your productivity is currently 'Sub-Optimal'. Fix it.",
    "Is a checkmark too much for your organic limbs to handle?",
    "Logging progress is a non-negotiable directive. Execute.",
  ];

  /// Professional coaching prompts for elite reinforcement.
  static const List<String> eliteMessages = [
    "System Check: Are you winning the day?",
    "Discipline equals freedom. Review your dashboard.",
    "Small daily steps build empires. Don't break your streak.",
    "Elite focus required. Execute your goals.",
    "Your potential is defined by your consistency.",
    "Momentum is built in the shadows. Keep working.",
    "No zero days. Move the needle now.",
    "Architect your future. Check off today's habits.",
    "The version of you next year depends on today's choices.",
    "Excellence is a habit, not an act. Stay sharp.",
    "Master your habits, master your life.",
    "Shalcontech Intelligence: Data suggests you're due for a win.",
  ];

  /// Gen Z style prompts - informal and trendy.
  static const List<String> genZMessages = [
    "No cap, your streak is looking fire. Keep it up! 🔥",
    "Don't let your habits ghost you. Log them now! 💀",
    "Main character energy only. Finish your tasks! 💅",
    "Your future self is literally screaming. Do the work! 📢",
    "POV: You're actually reaching your goals. 📸",
    "Don't be mid. Be elite. Check your tasks. 💯",
    "Respect the hustle. Your streak is iconic. 🛐",
    "No zero days, fr fr. 😤",
    "Vibe check: Are you winning yet? 🤙",
  ];

  /// Helper to get a random motivational prompt based on persona.
  /// Defaults to [eliteMessages] if persona is unknown.
  static String getRandomPrompt(String persona) {
    final Random random = Random();
    List<String> messages;

    switch (persona.toLowerCase()) {
      case 'genz':
        messages = genZMessages;
        break;
      case 'overlord':
      case 'habito':
      case 'shelby':
        messages = overlordMessages;
        break;
      case 'elite':
      case 'professional':
      default:
        messages = eliteMessages;
        break;
    }

    return messages[random.nextInt(messages.length)];
  }
}
