import 'dart:math';
import 'dart:io';
import 'habit_notifications.dart';
import 'habit_notifications_for_her.dart';
import 'habit_notifications_genz.dart';

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
    "Success is the sum of small habits, repeated day in and day out.",
    "Focus on the process, and the results will take care of themselves.",
    "Great things are done by a series of small things brought together.",
    "Discipline is choosing between what you want now and what you want most.",
    "Your habits are the building blocks of your ultimate potential.",
    "Stay dedicated. Rome wasn't built in a day, but they worked on it daily.",
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
    "Normalize finishing your habits daily, bestie. 💅",
    "This is your sign to lock in and get it done. 🔒",
    "Your streak is literally giving productivity god. 👑",
    "Habits on fleek, rent is free, let's go. 🚀",
    "Unlocking main character status, one habit at a time. ✨",
    "Out here living your best disciplined life, fr. 📈",
  ];

  static bool _isIndianRegion() {
    try {
      final locale = Platform.localeName.toLowerCase();
      if (locale.contains('_in') || locale.startsWith('hi')) {
        return true;
      }
      final offset = DateTime.now().timeZoneOffset;
      final tzName = DateTime.now().timeZoneName.toLowerCase();
      return offset.inMinutes == 330 ||
          tzName.contains('kolkata') ||
          tzName == 'ist';
    } catch (_) {
      return false;
    }
  }

  static List<String> _getIndianMessages(String persona, String gender) {
    final bool isFemale = gender.toLowerCase() == 'female';
    switch (persona.toLowerCase()) {
      case 'genz':
        return isFemale
            ? [
                ...HabitNotificationsGenZForHer.cute,
                ...HabitNotificationsGenZForHer.flirty,
                ...HabitNotificationsGenZForHer.romantic,
              ]
            : [
                ...HabitNotificationsGenZ.cute,
                ...HabitNotificationsGenZ.flirty,
                ...HabitNotificationsGenZ.romantic,
              ];
      case 'overlord':
      case 'habito':
      case 'shelby':
        return isFemale
            ? [
                ...HabitNotificationsForHer.roast,
                ...HabitNotificationsForHer.breakup,
              ]
            : [...HabitNotifications.roast, ...HabitNotifications.breakup];
      case 'elite':
      case 'professional':
      default:
        return isFemale
            ? [
                ...HabitNotificationsForHer.discipline,
                ...HabitNotificationsForHer.motivational,
              ]
            : [
                ...HabitNotifications.discipline,
                ...HabitNotifications.motivational,
              ];
    }
  }

  /// Helper to get a random motivational prompt based on persona.
  /// Defaults to [eliteMessages] if persona is unknown.
  static String getRandomPrompt(String persona, {String gender = "Male"}) {
    final Random random = Random();
    List<String> messages;

    if (_isIndianRegion()) {
      messages = _getIndianMessages(persona, gender);
    } else {
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
    }

    String msg = messages[random.nextInt(messages.length)];
    if (msg.contains('{X}')) {
      msg = msg.replaceAll('Streak: {X} din.', 'Daily streak');
    }
    return msg;
  }

  static String getPromptForDay(
    String persona,
    int weekday, {
    String gender = "Male",
  }) {
    List<String> messages;

    if (_isIndianRegion()) {
      messages = _getIndianMessages(persona, gender);
    } else {
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
    }

    final int index = (weekday - 1) % messages.length;
    String msg = messages[index];
    if (msg.contains('{X}')) {
      msg = msg.replaceAll('Streak: {X} din.', 'Daily streak');
    }
    return msg;
  }

  static List<String> getUniquePromptsForWeek(
    String persona, {
    String gender = "Male",
  }) {
    List<String> pool;

    if (_isIndianRegion()) {
      pool = List.from(_getIndianMessages(persona, gender));
    } else {
      switch (persona.toLowerCase()) {
        case 'genz':
          pool = List.from(genZMessages);
          break;
        case 'overlord':
        case 'habito':
        case 'shelby':
          pool = List.from(overlordMessages);
          break;
        case 'elite':
        case 'professional':
        default:
          pool = List.from(eliteMessages);
          break;
      }
    }

    final random = Random();
    final List<String> result = List.filled(14, "");

    // Shuffle the pool for morning slots
    final List<String> morningPool = List.from(pool)..shuffle(random);
    for (int i = 0; i < 7; i++) {
      result[i] = morningPool[i % morningPool.length];
    }

    // Select evening slots ensuring morning & evening of the same day differ
    final List<String> eveningPool = List.from(pool)..shuffle(random);
    for (int i = 0; i < 7; i++) {
      final morningMsg = result[i];
      String chosen = "";
      for (int j = 0; j < eveningPool.length; j++) {
        if (eveningPool[j] != morningMsg) {
          chosen = eveningPool.removeAt(j);
          break;
        }
      }
      if (chosen.isEmpty) {
        chosen = morningMsg;
      }
      result[i + 7] = chosen;
    }

    // Replace templates/placeholders
    for (int i = 0; i < result.length; i++) {
      if (result[i].contains('{X}')) {
        result[i] = result[i].replaceAll('Streak: {X} din.', 'Daily streak');
      }
    }

    return result;
  }

  static String getStatusTitle(String persona) {
    switch (persona.toLowerCase()) {
      case 'genz':
        return "Vibe Sync Complete ⚡";
      case 'overlord':
      case 'habito':
      case 'shelby':
        return "Neural Sync Complete ⚡";
      case 'elite':
      case 'professional':
      default:
        return "System Sync Complete ⚡";
    }
  }

  static String getStatusBody(String persona, {String context = ""}) {
    switch (persona.toLowerCase()) {
      case 'genz':
        if (context == "motivation") {
          return "GenZ Coach is active, fr fr! Time to level up bestie. 💅";
        }
        return "GenZ Coach is active and ready to lock in. fr fr! 🚀";
      case 'overlord':
      case 'habito':
      case 'shelby':
        if (context == "motivation") {
          return "Overlord Engine is active and monitoring daily motivation.";
        }
        return "Overlord Engine is active. System Status: ELITE.";
      case 'elite':
      case 'professional':
      default:
        if (context == "motivation") {
          return "Professional Coach is active and monitoring daily discipline.";
        }
        return "Professional Coach is active. System Status: OPTIMAL.";
    }
  }
}
