import 'package:flutter/material.dart';
import '../../domain/models/shelby_persona.dart';

/// Display metadata for Shelby personas — names, subtitles, icons.
class PersonaDisplayHelpers {
  static String displayName(ShelbyPersona persona) {
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

  static String subtitle(String personaStr) {
    final p = personaStr.toLowerCase();
    if (p.contains("professional") || p.contains("motivation")) return "Elite, disciplined reinforcement style";
    if (p.contains("genz")) return "Informal, trendy, high-energy vibes";
    if (p.contains("overlord") || p.contains("shelby")) return "Sarcastic, sentient AI Overlord protocol";
    if (p.contains("flirty")) return "Playful, charming Hinglish prompts";
    if (p.contains("roast")) return "Spicy, sarcastic reality checks";
    if (p.contains("cute")) return "Sweet, baby-shona encouragement";
    if (p.contains("romantic")) return "Warm, caring relationship support";
    if (p.contains("breakup")) return "Guilt-trip, situationship intervention";
    return "Elite habit builder mood";
  }

  static IconData icon(String personaStr) {
    final p = personaStr.toLowerCase();
    if (p.contains("professional") || p.contains("motivation")) return Icons.work_rounded;
    if (p.contains("genz")) return Icons.bolt_rounded;
    if (p.contains("overlord") || p.contains("shelby")) return Icons.psychology_rounded;
    if (p.contains("flirty")) return Icons.favorite_rounded;
    if (p.contains("roast")) return Icons.local_fire_department_rounded;
    if (p.contains("cute")) return Icons.child_care_rounded;
    if (p.contains("romantic")) return Icons.favorite_border_rounded;
    if (p.contains("breakup")) return Icons.sentiment_very_dissatisfied_rounded;
    return Icons.mood_rounded;
  }

  static String statusTitle(String persona) {
    switch (persona.toLowerCase()) {
      case 'genz':
        return "Vibe Sync Complete ⚡";
      case 'overlord':
      case 'habito':
      case 'shelby':
        return "Neural Sync Complete ⚡";
      default:
        return "System Sync Complete ⚡";
    }
  }

  static String statusBody(String persona, {String context = ""}) {
    switch (persona.toLowerCase()) {
      case 'genz':
        return context == "motivation"
            ? "GenZ Coach is active, fr fr! Time to level up bestie. 💅"
            : "GenZ Coach is active and ready to lock in. fr fr! 🚀";
      case 'overlord':
      case 'habito':
      case 'shelby':
        return context == "motivation"
            ? "Overlord Engine is active and monitoring daily motivation."
            : "Overlord Engine is active. System Status: ELITE.";
      default:
        return context == "motivation"
            ? "Professional Coach is active and monitoring daily discipline."
            : "Professional Coach is active. System Status: OPTIMAL.";
    }
  }
}
