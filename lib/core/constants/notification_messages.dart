import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'habit_notifications.dart';
import 'habit_notifications_for_her.dart';
import 'habit_notifications_genz.dart';
import '../../domain/models/shelby_persona.dart';
import 'notification_pools.dart';
import 'in_app_briefings.dart';
import 'persona_display_helpers.dart';

class NotificationMessages {
  /// Sarcastic, sentient AI Overlord prompts (Habito AI / SHELBY).
  /// Based on the 'AI Overlord' persona from project documentation.
  static const List<String> overlordMessages = NotificationPools.overlordMessages;

  /// Professional coaching prompts for elite reinforcement.
  static const List<String> eliteMessages = NotificationPools.eliteMessages;

  /// Gen Z style prompts - informal and trendy.
  static const List<String> genZMessages = NotificationPools.genZMessages;

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

  static String getStatusTitle(String persona) =>
      PersonaDisplayHelpers.statusTitle(persona);

  static String getStatusBody(String persona, {String context = ""}) =>
      PersonaDisplayHelpers.statusBody(persona, context: context);

  static String getPersonaDisplayName(ShelbyPersona persona) =>
      PersonaDisplayHelpers.displayName(persona);

  static String getPersonaSubtitle(String personaStr) =>
      PersonaDisplayHelpers.subtitle(personaStr);

  static IconData getPersonaIcon(String personaStr) =>
      PersonaDisplayHelpers.icon(personaStr);

  static String getInAppBriefing({
    required ShelbyPersona persona,
    required String context, // 'empty', 'nudge', 'momentum', 'celebration', 'midday', 'reflection'
    required String username,
    int completed = 0,
    int total = 0,
    int streak = 0,
  }) {
    return InAppBriefings.getInAppBriefing(
      persona: persona,
      context: context,
      username: username,
      completed: completed,
      total: total,
      streak: streak,
    );
  }
}
