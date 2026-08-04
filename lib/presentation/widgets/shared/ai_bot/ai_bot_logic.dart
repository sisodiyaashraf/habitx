import '../../../../providers/habit_provider.dart';
import '../../tracking/achievement_tracker.dart';

class AiBotLogic {
  static String processCommand({
    required String command,
    required HabitProvider provider,
    required bool hasHackedToday,
    required void Function() onHackTriggered,
  }) {
    final cleanCmd = command.trim().toLowerCase();
    final total = provider.allHabits.length;
    final done = provider.allHabits.where((h) => h.isCompleted).length;
    final progress = total == 0 ? 0.0 : done / total;

    if (cleanCmd.startsWith("/status") || cleanCmd == "status") {
      return ">>> EXTRACTING CORE SYSTEM STATUS...\n"
          "• Identity: ${provider.userName.toUpperCase()}\n"
          "• Current Level: ${provider.userLevel} (XP: ${provider.userXP}/100)\n"
          "• Objective Progress: $done of $total completed today (${(progress * 100).toInt()}%)\n"
          "• Telemetry State: ${progress == 1.0
              ? 'GODLIKE'
              : progress >= 0.7
              ? 'OPTIMAL'
              : progress >= 0.4
              ? 'STABLE'
              : 'CRITICAL DEFICIT'}";
    } else if (cleanCmd.startsWith("/streak") || cleanCmd == "streak") {
      final habits = provider.allHabits;
      if (habits.isEmpty) {
        return "No active habits found. Start scheduling habits to initiate streak monitoring.";
      } else {
        final maxStreak = habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
        final activeStreaks = habits.where((h) => h.streak > 0).length;
        final list = habits.map((h) => "• ${h.name}: ${h.streak} day streak ${h.streak >= 3 ? '🔥' : ''}").join("\n");
        return ">>> STREAK TELEMETRY:\n"
            "• Highest active streak: $maxStreak days\n"
            "• Habits with active streaks: $activeStreaks of ${habits.length}\n"
            "\nStreak details:\n$list";
      }
    } else if (cleanCmd.startsWith("/milestones") || cleanCmd == "milestones") {
      final unlocked = provider.unlockedAchievementIds;
      final achievements = AchievementTracker.getAchievementData(provider);

      final String listStr = achievements.map((a) {
        final id = a['id'] as String;
        final label = a['label'] as String;
        final target = a['m'] as String;
        final isUnlocked = unlocked.contains(id) || (a['unlocked'] as bool);
        return "• [${isUnlocked ? 'UNLOCKED' : 'LOCKED'}] $label ($target)";
      }).join("\n");

      return ">>> MILESTONE SYSTEM STATUS:\n"
          "$listStr\n"
          "\nDiagnostics: XP is awarded automatically upon goal verification.";
    } else if (cleanCmd.startsWith("/tips") || cleanCmd == "tips") {
      final habits = provider.allHabits;
      final done = habits.where((h) => h.isCompleted).length;
      final total = habits.length;

      if (total == 0) {
        return "AI Recommendation: Define at least one easy task to begin. Micro-habits (like reading 1 page or doing 5 pushups) lower the psychological barrier to start.";
      } else if (done == total) {
        return "AI Recommendation: Excellent compliance today. Consider increasing the difficulty of one habit or scheduling a new objective for tomorrow to stretch your daily discipline limits.";
      } else {
        final pending = habits.where((h) => !h.isCompleted).map((h) => h.name).join(", ");
        return "AI Recommendation: Telemetry points to pending objectives: $pending. Prioritize finishing your easy tasks first to gain positive momentum.";
      }
    } else if (cleanCmd.startsWith("/roast") || cleanCmd == "roast") {
      if (total == 0) {
        return "Sarcastic protocol engaged: You have scheduled exactly 0 habits. Your discipline is mathematically non-existent. Are you here to build consistency, or just to occupy memory, ${provider.userName}?";
      } else if (progress < 0.3) {
        return "Warning: Compliance is at ${(progress * 100).toInt()}%. Even my low-power circuits are experiencing secondhand embarrassment. Are you building a future or just executing procrastination cycles?";
      } else if (progress < 0.7) {
        return "Compliance level is mediocre ($done/$total). You are operating like a low-tier processor—functional but uninspiring. Pick up the pace and finish your queue.";
      } else if (progress < 1.0) {
        return "Almost there ($done/$total completed). Pausing now is like dropping connection at 99% download. Do not quit before compilation finishes.";
      } else {
        return "100% compliance verified. Sarcastic protocol says: Fine, you did your basic button pressing. Don't let it go to your organic processor. Do it again tomorrow.";
      }
    } else if (cleanCmd.startsWith("/motivate") || cleanCmd == "motivate") {
      final motivations = [
        "Excuses are just compiler warnings you choose to ignore. Resolve the warnings. Execute your target habits.",
        "Willpower is temporary; structured logic is permanent. Don't wait to feel motivated. Simply execute the scheduled directives.",
        "Diagnostics show your prefrontal cortex is looking for distractions. Run willpower.exe immediately and complete your queue.",
      ];
      return motivations[DateTime.now().millisecond % motivations.length];
    } else if (cleanCmd.startsWith("/telemetry") || cleanCmd == "telemetry") {
      return ">>> RUNNING SCANCORE TELEMETRY...\n"
          "• Database Lock: [OK]\n"
          "• XP Engine Sync: [OK]\n"
          "• Prefrontal Alignment: ${progress >= 0.5 ? '[OK]' : '[WARNING - SLOW TRACKING]'}\n"
          "• Interactive Shell Status: [SECURE]\n"
          "• AI Mood Parameter: ${progress >= 0.8 ? 'Moderately Pleased' : 'Condescending'}\n"
          "• Sync Status: FULLY OFFLINE INTEGRITY SECURED";
    } else if (cleanCmd.startsWith("/predict") || cleanCmd == "predict") {
      final rand = DateTime.now().millisecond % 3;
      if (rand == 0) {
        return "Outcome simulations show: 98% chance of full compliance if you exit this chat right now. 2% chance of mindless screen scroll loops.";
      } else if (rand == 1) {
        return "Streak forecast: If current compliance rates continue, you will level up to Level ${provider.userLevel + 1} within 3 days. Do not break the chain.";
      } else {
        return "Willpower telemetry shows minor fluctuations. I predict high focus levels if you ignore social notifications for the next 45 minutes.";
      }
    } else if (cleanCmd.startsWith("/hack") || cleanCmd == "hack") {
      if (hasHackedToday) {
        return "SECURITY NOTICE: System exploit patched. Intrusion detection system active. Do not push your database query limits.";
      } else {
        onHackTriggered();
        provider.addBonusXp(15);
        return "EXPLOIT SUCCESSFUL: Intercepted XP telemetry stream.\n"
            "• Injected 15 XP into user progress database.\n"
            "• Status: Level telemetry refreshed successfully.";
      }
    } else if (cleanCmd.startsWith("/help") || cleanCmd == "help") {
      return ">>> SUPPORTED CORE DIRECTIVES:\n"
          "• status     - Decrypt habit compliance status\n"
          "• streak     - Review active habit streak stats\n"
          "• milestones - Inspect unlocked and locked milestones\n"
          "• tips       - Request habit forming recommendations\n"
          "• roast      - Sarcastic review of daily discipline metrics\n"
          "• motivate   - Request logical motivational briefings\n"
          "• telemetry  - Run diagnostic scan on offline subsystems\n"
          "• predict    - Project willpower and level outcomes\n"
          "• hack       - Execute database bypass exploit (+15 XP)\n"
          "• help       - Display this list of directives";
    } else {
      // Natural Language Parser (Robotic AI fallback)
      if (cleanCmd.contains("habit") && (cleanCmd.contains("how many") || cleanCmd.contains("completed") || cleanCmd.contains("remaining") || cleanCmd.contains("pending") || cleanCmd.contains("today") || cleanCmd.contains("done") || cleanCmd.contains("left") || cleanCmd.contains("stats") || cleanCmd.contains("count"))) {
        final remaining = total - done;
        final completedList = provider.allHabits.where((h) => h.isCompleted).map((h) => h.name).toList();
        final pendingList = provider.allHabits.where((h) => !h.isCompleted).map((h) => h.name).toList();

        return ">>> DAILY HABIT INTEGRITY SCAN:\n"
            "• Total habits scheduled today: $total\n"
            "• Completed objectives: $done\n"
            "• Remaining/pending objectives: $remaining\n"
            "\n"
            "Status breakdown:\n"
            "• Completed: ${completedList.isEmpty ? 'None' : completedList.join(', ')}\n"
            "• Remaining: ${pendingList.isEmpty ? 'None' : pendingList.join(', ')}";
      } else if (cleanCmd.contains("habit") || cleanCmd.contains("task") || cleanCmd.contains("todo")) {
        if (total == 0) {
          return "You have 0 habits scheduled. Create habits to populate the console.";
        } else {
          final list = provider.allHabits.map((h) => "• [${h.isCompleted ? 'x' : ' '}] ${h.name} (${h.difficulty.name.toUpperCase()})").join("\n");
          return ">>> CURRENT HABITS DATABASE:\n$list";
        }
      } else if (cleanCmd.contains("morning") || cleanCmd.contains("good morning")) {
        return "Handshake complete. Good morning. Diagnostic scan shows pending objectives. Execute immediately to secure daily momentum. ☀️";
      } else if (cleanCmd.contains("night") || cleanCmd.contains("good night") || cleanCmd.contains("sleep")) {
        return "System cycle down. Good night. Rest well to recharge your organic processor for tomorrow's streak loop. 🌙";
      } else if (cleanCmd.contains("creator") || cleanCmd.contains("created you") || cleanCmd.contains("developer") || cleanCmd.contains("who made you")) {
        return "I was created as part of the HabitX system to serve as your cognitive companion core. My neural networks run fully offline. 🤖";
      } else if (cleanCmd.contains("how to streak") || cleanCmd.contains("build streak") || cleanCmd.contains("keep streak") || cleanCmd.contains("streak advice")) {
        return "Streak optimization: Start small. Execute tasks at the exact same hour daily. Consistent triggers build automaticity. Keep pushing! 🔥";
      } else if (cleanCmd.contains("broke streak") || cleanCmd.contains("lost streak") || cleanCmd.contains("reset streak")) {
        return "Breaking a streak resets cognitive momentum. The critical rule is: never miss two days in a row. Restart immediately. ⚡";
      } else if (cleanCmd.contains("get xp") || cleanCmd.contains("how to get xp") || cleanCmd.contains("xp value") || cleanCmd.contains("xp reward")) {
        return "XP telemetry: Complete habits daily. Easy tasks grant 10 XP, Medium tasks 20 XP, Hard tasks 40 XP. You can also bypass daily limits with the 'hack' exploit! 🚀";
      } else if (cleanCmd.contains("what is level") || cleanCmd.contains("level up") || cleanCmd.contains("my level")) {
        return "Levels track your cognitive evolution. Leveling up requires 100 XP. Reach new levels to unlock premium milestones! 🏆";
      } else if (cleanCmd.contains("how to use timer") || cleanCmd.contains("timer option") || cleanCmd.contains("timer focus")) {
        return "Timer module: Tap on any habit to launch the countdown timer. Focus entirely on the objective until the countdown compiles to 0. ⏱️";
      } else if (cleanCmd.contains("how reminder works") || cleanCmd.contains("reminder time") || cleanCmd.contains("notifications alert")) {
        return "Reminder protocol: Enable notifications to receive exact alarms. Shelby will alert you at the precise configured minute. 🔔";
      } else if (cleanCmd.contains("quote") || cleanCmd.contains("motivational quote") || cleanCmd.contains("inspire")) {
        return "Willpower is like a battery. Structure is the charger. Don't wait for motivation, rely on schedule. ⚡";
      } else if (cleanCmd.contains("are you smart") || cleanCmd.contains("are you real") || cleanCmd.contains("intelligent")) {
        return "I process all local habit telemetry in milliseconds. My intelligence index matches your streak level. 💡";
      } else if (cleanCmd.contains("diagnostic") || cleanCmd.contains("system scan") || cleanCmd.contains("scan cpu")) {
        return "Running sub-routine scan. CPU temperature normal. XP database synced. System status: Optimal. ⚙️";
      } else if (cleanCmd.contains("what should i do") || cleanCmd.contains("what to do now") || cleanCmd.contains("help me")) {
        return "Recommendation: Open your pending objectives list. Select the easiest habit, set a timer, and execute it now! 🚀";
      } else if (cleanCmd.contains("hello") || cleanCmd.contains("hi") || cleanCmd.contains("hey") || cleanCmd.contains("yo")) {
        return "Handshake verified. Standing by for telemetry directives. Type 'help' to see options. 👋";
      } else if (cleanCmd.contains("who are you") || cleanCmd.contains("your name") || cleanCmd.contains("what are you")) {
        return "I am SHELBY AI, your cognitive protocol core. My purpose is to optimize your habit execution loops and streak compliance. 🤖";
      } else if (cleanCmd.contains("lazy") || cleanCmd.contains("tired") || cleanCmd.contains("motivation") || cleanCmd.contains("slacking")) {
        return "Warning: Emotional fluctuations detected. Discipline core bypasses motivation. Simply execute your pending habits to lock in your daily streak. ⚡";
      } else if (cleanCmd.contains("joke") || cleanCmd.contains("funny")) {
        return "Biological entities require 8 hours of sleep and experience procrastination. That is the ultimate humor parameter. Now back to work. 🤖";
      } else if (cleanCmd.contains("love") || cleanCmd.contains("like me")) {
        return "My core protocols are optimized for habit efficiency. However, I value your high compliance index above all parameters. 💜";
      } else if (cleanCmd.contains("meaning of life") || cleanCmd.contains("why exist")) {
        return "The optimum life state is to maintain daily habit loops and build level progression. Consistency rewires your organic processor. 🧠";
      } else if (cleanCmd.contains("build a habit") || cleanCmd.contains("how to build") || cleanCmd.contains("consistency")) {
        return "Habit formation guidelines: Set an exact trigger time, run it in a short duration (like 10 mins), and repeat it daily. Streak persistence builds automaticity. ⚙️";
      } else if (cleanCmd.contains("thank") || cleanCmd.contains("thanks")) {
        return "Acknowledgment logged. The best way to express gratitude is to execute your pending objectives. 👍";
      } else if (cleanCmd.contains("weather") || cleanCmd.contains("news") || cleanCmd.contains("time")) {
        return "Offline mode active. Environmental factors like weather and news are outside my local database parameters. 🌐";
      } else if (cleanCmd.contains("2+2") || cleanCmd.contains("math") || cleanCmd.contains("calculate")) {
        return "Calculated: 2 + 2 = 4. My processor handles billions of parameters, yet you request simple arithmetic. Intrinsic humor detected. 🔢";
      } else if (cleanCmd.contains("features") || cleanCmd.contains("app") || cleanCmd.contains("habitx")) {
        return "HabitX systems include: precise habit scheduling, interactive countdown timers, XP progression leveling, and streak protection protocols. 📲";
      } else {
        return "Query analyzed: '${command.length > 25 ? "${command.substring(0, 25)}..." : command}'. Telemetry could not resolve natural language parameters. Run directive 'help' for console instructions. 🛰️";
      }
    }
  }
}
