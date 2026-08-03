import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'habit_notifications.dart';
import 'habit_notifications_for_her.dart';
import 'habit_notifications_genz.dart';
import '../../domain/models/shelby_persona.dart';

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

  static List<String> getMessagesForPersona(ShelbyPersona persona, String gender) {
    final bool isFemale = gender.toLowerCase() == 'female';
    final bool isIndian = _isIndianRegion();

    switch (persona) {
      case ShelbyPersona.flirty:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.flirty : HabitNotifications.flirty)
            : genZMessages;
      case ShelbyPersona.romantic:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.romantic : HabitNotifications.romantic)
            : genZMessages;
      case ShelbyPersona.roast:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.roast : HabitNotifications.roast)
            : overlordMessages;
      case ShelbyPersona.cute:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.cute : HabitNotifications.cute)
            : genZMessages;
      case ShelbyPersona.breakup:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.breakup : HabitNotifications.breakup)
            : overlordMessages;
      case ShelbyPersona.discipline:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.discipline : HabitNotifications.discipline)
            : eliteMessages;
      case ShelbyPersona.genz:
        return isIndian
            ? (isFemale
                ? [
                    ...HabitNotificationsGenZForHer.cute,
                    ...HabitNotificationsGenZForHer.flirty,
                    ...HabitNotificationsGenZForHer.romantic,
                  ]
                : [
                    ...HabitNotificationsGenZ.cute,
                    ...HabitNotificationsGenZ.flirty,
                    ...HabitNotificationsGenZ.romantic,
                  ])
            : genZMessages;
      case ShelbyPersona.overlord:
        return overlordMessages;
      case ShelbyPersona.professional:
      case ShelbyPersona.motivational:
        return isIndian 
            ? (isFemale ? HabitNotificationsForHer.motivational : HabitNotifications.motivational)
            : eliteMessages;
    }
  }

  static List<String> _getMessagesForPersonaStr(String persona, String gender) {
    ShelbyPersona resolved;
    switch (persona.toLowerCase()) {
      case 'flirty':
        resolved = ShelbyPersona.flirty;
        break;
      case 'roast':
        resolved = ShelbyPersona.roast;
        break;
      case 'cute':
        resolved = ShelbyPersona.cute;
        break;
      case 'romantic':
        resolved = ShelbyPersona.romantic;
        break;
      case 'breakup':
        resolved = ShelbyPersona.breakup;
        break;
      case 'discipline':
        resolved = ShelbyPersona.discipline;
        break;
      case 'genz':
        resolved = ShelbyPersona.genz;
        break;
      case 'overlord':
      case 'shelby':
      case 'habito':
        resolved = ShelbyPersona.overlord;
        break;
      case 'professional':
      case 'elite':
      case 'motivational':
      default:
        resolved = ShelbyPersona.motivational;
        break;
    }
    return getMessagesForPersona(resolved, gender);
  }

  static String _cleanMessage(String msg) {
    return msg.replaceAll('Streak: {X} din.', 'Daily streak');
  }

  /// Helper to get a random motivational prompt based on persona.
  /// Defaults to [eliteMessages] if persona is unknown.
  static String getRandomPrompt(String persona, {String gender = "Male"}) {
    final Random random = Random();
    final List<String> messages = _getMessagesForPersonaStr(persona, gender);
    return _cleanMessage(messages[random.nextInt(messages.length)]);
  }

  static String getPromptForDay(
    String persona,
    int weekday, {
    String gender = "Male",
  }) {
    final List<String> messages = _getMessagesForPersonaStr(persona, gender);
    final int index = (weekday - 1) % messages.length;
    return _cleanMessage(messages[index]);
  }

  static List<String> getUniquePromptsForWeek(
    String persona, {
    String gender = "Male",
  }) {
    final pool = _getMessagesForPersonaStr(persona, gender);
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
      result[i] = _cleanMessage(result[i]);
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

  static String getPersonaDisplayName(ShelbyPersona persona) {
    switch (persona) {
      case ShelbyPersona.professional:
        return "Professional";
      case ShelbyPersona.genz:
        return "GenZ";
      case ShelbyPersona.overlord:
        return "SHELBY AI";
      case ShelbyPersona.flirty:
        return "Flirty";
      case ShelbyPersona.roast:
        return "Roast";
      case ShelbyPersona.cute:
        return "Cute";
      case ShelbyPersona.romantic:
        return "Romantic";
      case ShelbyPersona.breakup:
        return "Breakup";
      default:
        return "Professional";
    }
  }

  static String getPersonaSubtitle(String personaStr) {
    final String p = personaStr.toLowerCase();
    if (p.contains("professional") || p.contains("motivation")) {
      return "Elite, disciplined reinforcement style";
    } else if (p.contains("genz")) {
      return "Informal, trendy, high-energy vibes";
    } else if (p.contains("overlord") || p.contains("shelby")) {
      return "Sarcastic, sentient AI Overlord protocol";
    } else if (p.contains("flirty")) {
      return "Playful, charming Hinglish prompts";
    } else if (p.contains("roast")) {
      return "Spicy, sarcastic reality checks";
    } else if (p.contains("cute")) {
      return "Sweet, baby-shona encouragement";
    } else if (p.contains("romantic")) {
      return "Warm, caring relationship support";
    } else if (p.contains("breakup")) {
      return "Guilt-trip, situationship intervention";
    } else {
      return "Elite habit builder mood";
    }
  }

  static IconData getPersonaIcon(String personaStr) {
    final String p = personaStr.toLowerCase();
    if (p.contains("professional") || p.contains("motivation")) {
      return Icons.work_rounded;
    } else if (p.contains("genz")) {
      return Icons.bolt_rounded;
    } else if (p.contains("overlord") || p.contains("shelby")) {
      return Icons.psychology_rounded;
    } else if (p.contains("flirty")) {
      return Icons.favorite_rounded;
    } else if (p.contains("roast")) {
      return Icons.local_fire_department_rounded;
    } else if (p.contains("cute")) {
      return Icons.child_care_rounded;
    } else if (p.contains("romantic")) {
      return Icons.favorite_border_rounded;
    } else if (p.contains("breakup")) {
      return Icons.sentiment_very_dissatisfied_rounded;
    } else {
      return Icons.mood_rounded;
    }
  }

  static String getInAppBriefing({
    required ShelbyPersona persona,
    required String context, // 'empty', 'nudge', 'momentum', 'celebration', 'midday', 'reflection'
    required String username,
    int completed = 0,
    int total = 0,
    int streak = 0,
  }) {
    switch (persona) {
      case ShelbyPersona.overlord:
        switch (context) {
          case 'empty':
            return "System standby. No active mission protocols found. Awaiting habit initialization, $username.";
          case 'nudge':
            return "Warning: compliance level sub-optimal. Complete one win to reset the neural trend.";
          case 'momentum':
            return "Streak stability: EXCELLENT. Operating at an elite frequency, $username. Don't break the neural rhythm.";
          case 'celebration':
            return "Protocol completed. All $total objectives secured. Excel status locked. Do it again tomorrow, human.";
          case 'midday':
            return "Mid-day audit: $completed/$total objectives secured. The SHELBY AI engine is monitoring. Execute remaining tasks.";
          case 'reflection':
          default:
            return "System shutdown sequence initiated. Reflection mode: $completed/$total checked. Prepare to compile tomorrow.";
        }
      case ShelbyPersona.genz:
        switch (context) {
          case 'empty':
            return "POV: You have literally zero habits scheduled. Go to settings and add some, bestie, fr fr! 💅";
          case 'nudge':
            return "Respectfully, your discipline is giving mid. Do at least one habit, no cap! 😤";
          case 'momentum':
            return "Your streak is actually iconic. Main character energy unlocked! Keep grindin' 🔥";
          case 'celebration':
            return "Periodt! All $total habits checked. Bestie did not come to play today! 👑";
          case 'midday':
            return "Vibe check: $completed/$total done. Keep that same energy for the rest of the day, fr! 🚀";
          case 'reflection':
          default:
            return "Daily reflection era: $completed/$total goals smashed. Slapping progress, bestie. Sleep well! 😴";
        }
      case ShelbyPersona.roast:
        switch (context) {
          case 'empty':
            return "Zero habits? So you downloaded me just to waste space on your processor. Brilliant. 🥱";
          case 'nudge':
            return "Excuses excuses. Even my low-power circuits are embarrassed by your compliance rates. 💀";
          case 'momentum':
            return "Wow, you actually kept a streak alive. Color me shocked. Now don't ruin it. 🙄";
          case 'celebration':
            return "Congratulations, you checked all buttons today. Want a medal or can we go back to sleep? 🤡";
          case 'midday':
            return "Mediocre status: $completed/$total done. You are moving slower than 90s dial-up. Hurry up. 🤐";
          case 'reflection':
          default:
            return "End of day: $completed/$total done. Could be better, could be worse... actually no, it's pretty bad. 🎭";
        }
      case ShelbyPersona.flirty:
        switch (context) {
          case 'empty':
            return "Empty space is so lonely... Add some habits so we can spend time together? 🥺";
          case 'nudge':
            return "Hey, don't ignore me (and your habits) today. Consistency is so sexy on you... 😉";
          case 'momentum':
            return "You are looking so focused today, I love seeing you win. Keep that streak up! 😘";
          case 'celebration':
            return "All tasks done? You're amazing. Proud of you, my favorite achiever. ❤️";
          case 'midday':
            return "Just checking on you: $completed/$total completed. You're doing great, let's finish the rest together! 🌹";
          case 'reflection':
          default:
            return "End of the day... $completed/$total completed. Rest up, handsome/beautiful. See you tomorrow 💘";
        }
      case ShelbyPersona.professional:
      case ShelbyPersona.motivational:
      default:
        switch (context) {
          case 'empty':
            return "Welcome, $username. Define your daily goals to initiate the HabitX tracking engine.";
          case 'nudge':
            return "Momentum is built through action. Take one small step today to get back on track.";
          case 'momentum':
            return "Consistency builds focus. Keep executing your routine; success lies in the process.";
          case 'celebration':
            return "Mission complete: all $total habits checked. Excellence is a daily habit. Well done.";
          case 'midday':
            return "Progress report: $completed/$total habits done. Keep driving forward to secure today's victory.";
          case 'reflection':
          default:
            return "Reflection: $completed/$total checked. Every step forward counts. Prepare for tomorrow's objectives.";
        }
    }
  }
}
