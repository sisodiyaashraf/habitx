import '../../domain/models/shelby_persona.dart';

class InAppBriefings {
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
