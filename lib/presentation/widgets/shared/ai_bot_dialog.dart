import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../providers/habit_provider.dart';

class AiBotDialog extends StatefulWidget {
  const AiBotDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => const AiBotDialog(),
    );
  }

  @override
  State<AiBotDialog> createState() => _AiBotDialogState();
}

class _AiBotDialogState extends State<AiBotDialog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, dynamic>> _chatHistory = [];

  bool _isTyping = false;
  bool _isThinking = false;
  String _typingText = "";
  Timer? _typewriterTimer;
  bool _hasHackedToday = false;
  bool _isAnalyzing = true;

  void _safeLightTap() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    _simulateNeuralScan();
  }

  void _simulateNeuralScan() {
    _chatHistory.add({
      "sender": "system",
      "text":
          "> Initializing SHELBY v5.0 offline protocols...\n> Establish handshake with local database...\n> Prefrontal cortex diagnostics synchronized.",
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        _scrollToBottom();
        _triggerInitialMessage();
      }
    });
  }

  void _triggerInitialMessage() {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    final total = provider.allHabits.length;
    final done = provider.allHabits.where((h) => h.isCompleted).length;
    final double progress = total == 0 ? 0.0 : done / total;

    String initialMsg = "";
    if (total == 0) {
      initialMsg =
          "Telemetry shows 0 active habits. Discipline core is idle. Instruct me with 'help' to configure new telemetry routines, or configure one in the console.";
    } else if (progress < 0.5) {
      initialMsg =
          "Warning: Current compliance is ${(progress * 100).toInt()}%. Cognitive momentum is sub-optimal. I recommend immediate execution of your pending habits. Type 'help' for options.";
    } else {
      initialMsg =
          "Diagnostics status: OPTIMAL. Completed $done/$total objectives today. High compliance verified. Keep executing to secure max XP. Command prompt is ready.";
    }

    _startTypewriter(initialMsg);
  }

  void _startTypewriter(String message) {
    if (mounted) {
      setState(() {
        _isTyping = true;
        _typingText = "";
      });
    }

    int charIndex = 0;
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 20), (
      timer,
    ) {
      try {
        if (charIndex < message.length) {
          if (mounted) {
            setState(() {
              _typingText += message[charIndex];
              charIndex++;
            });
            if (message[charIndex - 1] == '\n' || charIndex % 15 == 0) {
              _scrollToBottom();
            }
          }
        } else {
          timer.cancel();
          if (mounted) {
            setState(() {
              _isTyping = false;
              _chatHistory.add({"sender": "shelby", "text": _typingText});
              _typingText = "";
            });
            _scrollToBottom();
          }
        }
      } catch (e) {
        timer.cancel();
      }
    });
  }

  void _handleSendCommand(String text, HabitProvider provider) {
    if (text.trim().isEmpty) return;
    final cmd = text.trim();
    _inputController.clear();

    setState(() {
      _chatHistory.add({"sender": "user", "text": cmd});
    });
    _scrollToBottom();

    String response = "";
    final cleanCmd = cmd.toLowerCase();

    final total = provider.allHabits.length;
    final done = provider.allHabits.where((h) => h.isCompleted).length;
    final progress = total == 0 ? 0.0 : done / total;

    if (cleanCmd.startsWith("/status") || cleanCmd == "status") {
      response =
          ">>> EXTRACTING CORE SYSTEM STATUS...\n"
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
        response = "No active habits found. Start scheduling habits to initiate streak monitoring.";
      } else {
        final maxStreak = habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
        final activeStreaks = habits.where((h) => h.streak > 0).length;
        final list = habits.map((h) => "• ${h.name}: ${h.streak} day streak ${h.streak >= 3 ? '🔥' : ''}").join("\n");
        response = ">>> STREAK TELEMETRY:\n"
            "• Highest active streak: $maxStreak days\n"
            "• Habits with active streaks: $activeStreaks of ${habits.length}\n"
            "\nStreak details:\n$list";
      }
    } else if (cleanCmd.startsWith("/milestones") || cleanCmd == "milestones") {
      final habits = provider.allHabits;
      final totalDone = habits.where((h) => h.isCompleted).length;
      final maxStreak = habits.isEmpty ? 0 : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
      final unlocked = provider.unlockedAchievementIds;

      final initiateOk = unlocked.contains('initiate') || totalDone >= 1;
      final momentumOk = unlocked.contains('momentum') || maxStreak >= 3;
      final focusOk = unlocked.contains('focus') || maxStreak >= 7;
      final guardianOk = unlocked.contains('guardian') || totalDone >= 50;

      response = ">>> MILESTONE SYSTEM STATUS:\n"
          "• [${initiateOk ? 'UNLOCKED' : 'LOCKED'}] INITIATE (Complete 1 habit) - Reward: 100 XP\n"
          "• [${momentumOk ? 'UNLOCKED' : 'LOCKED'}] MOMENTUM (3-day streak) - Reward: 150 XP\n"
          "• [${focusOk ? 'UNLOCKED' : 'LOCKED'}] DEEP FOCUS (7-day streak) - Reward: 300 XP\n"
          "• [${guardianOk ? 'UNLOCKED' : 'LOCKED'}] GUARDIAN (50 total completions) - Reward: 500 XP\n"
          "\nDiagnostics: XP is awarded automatically upon goal verification.";
    } else if (cleanCmd.startsWith("/tips") || cleanCmd == "tips") {
      final habits = provider.allHabits;
      final done = habits.where((h) => h.isCompleted).length;
      final total = habits.length;

      if (total == 0) {
        response = "AI Recommendation: Define at least one easy task to begin. Micro-habits (like reading 1 page or doing 5 pushups) lower the psychological barrier to start.";
      } else if (done == total) {
        response = "AI Recommendation: Excellent compliance today. Consider increasing the difficulty of one habit or scheduling a new objective for tomorrow to stretch your discipline limits.";
      } else {
        final pending = habits.where((h) => !h.isCompleted).map((h) => h.name).join(", ");
        response = "AI Recommendation: Telemetry points to pending objectives: $pending. Prioritize finishing your easy tasks first to gain positive momentum.";
      }
    } else if (cleanCmd.startsWith("/roast") || cleanCmd == "roast") {
      if (total == 0) {
        response =
            "Sarcastic protocol engaged: You have scheduled exactly 0 habits. Your discipline is mathematically non-existent. Are you here to build consistency, or just to occupy memory, ${provider.userName}?";
      } else if (progress < 0.3) {
        response =
            "Warning: Compliance is at ${(progress * 100).toInt()}%. Even my low-power circuits are experiencing secondhand embarrassment. Are you building a future or just executing procrastination cycles?";
      } else if (progress < 0.7) {
        response =
            "Compliance level is mediocre ($done/$total). You are operating like a low-tier processor—functional but uninspiring. Pick up the pace and finish your queue.";
      } else if (progress < 1.0) {
        response =
            "Almost there ($done/$total completed). Pausing now is like dropping connection at 99% download. Do not quit before compilation finishes.";
      } else {
        response =
            "100% compliance verified. Sarcastic protocol says: Fine, you did your basic button pressing. Don't let it go to your organic processor. Do it again tomorrow.";
      }
    } else if (cleanCmd.startsWith("/motivate") || cleanCmd == "motivate") {
      final motivations = [
        "Excuses are just compiler warnings you choose to ignore. Resolve the warnings. Execute your target habits.",
        "Willpower is temporary; structured logic is permanent. Don't wait to feel motivated. Simply execute the scheduled directives.",
        "Diagnostics show your prefrontal cortex is looking for distractions. Run willpower.exe immediately and complete your queue.",
      ];
      response = motivations[DateTime.now().millisecond % motivations.length];
    } else if (cleanCmd.startsWith("/telemetry") || cleanCmd == "telemetry") {
      response =
          ">>> RUNNING SCANCORE TELEMETRY...\n"
          "• Database Lock: [OK]\n"
          "• XP Engine Sync: [OK]\n"
          "• Prefrontal Alignment: ${progress >= 0.5 ? '[OK]' : '[WARNING - SLOW TRACKING]'}\n"
          "• Interactive Shell Status: [SECURE]\n"
          "• AI Mood Parameter: ${progress >= 0.8 ? 'Moderately Pleased' : 'Condescending'}\n"
          "• Sync Status: FULLY OFFLINE INTEGRITY SECURED";
    } else if (cleanCmd.startsWith("/predict") || cleanCmd == "predict") {
      final rand = DateTime.now().millisecond % 3;
      if (rand == 0) {
        response =
            "Outcome simulations show: 98% chance of full compliance if you exit this chat right now. 2% chance of mindless screen scroll loops.";
      } else if (rand == 1) {
        response =
            "Streak forecast: If current compliance rates continue, you will level up to Level ${provider.userLevel + 1} within 3 days. Do not break the chain.";
      } else {
        response =
            "Willpower telemetry shows minor fluctuations. I predict high focus levels if you ignore social notifications for the next 45 minutes.";
      }
    } else if (cleanCmd.startsWith("/hack") || cleanCmd == "hack") {
      if (_hasHackedToday) {
        response =
            "SECURITY NOTICE: System exploit patched. Intrusion detection system active. Do not push your database query limits.";
      } else {
        _hasHackedToday = true;
        provider.addBonusXp(15);
        response =
            "EXPLOIT SUCCESSFUL: Intercepted XP telemetry stream.\n"
            "• Injected 15 XP into user progress database.\n"
            "• Status: Level telemetry refreshed successfully.";
      }
    } else if (cleanCmd.startsWith("/help") || cleanCmd == "help") {
      response =
          ">>> SUPPORTED CORE DIRECTIVES:\n"
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

        response = ">>> DAILY HABIT INTEGRITY SCAN:\n"
            "• Total habits scheduled today: $total\n"
            "• Completed objectives: $done\n"
            "• Remaining/pending objectives: $remaining\n"
            "\n"
            "Status breakdown:\n"
            "• Completed: ${completedList.isEmpty ? 'None' : completedList.join(', ')}\n"
            "• Remaining: ${pendingList.isEmpty ? 'None' : pendingList.join(', ')}";
      } else if (cleanCmd.contains("habit") || cleanCmd.contains("task") || cleanCmd.contains("todo")) {
        if (total == 0) {
          response = "You have 0 habits scheduled. Create habits to populate the console.";
        } else {
          final list = provider.allHabits.map((h) => "• [${h.isCompleted ? 'x' : ' '}] ${h.name} (${h.difficulty.name.toUpperCase()})").join("\n");
          response = ">>> CURRENT HABITS DATABASE:\n$list";
        }
      } else if (cleanCmd.contains("morning") || cleanCmd.contains("good morning")) {
        response = "Handshake complete. Good morning. Diagnostic scan shows pending objectives. Execute immediately to secure daily momentum. ☀️";
      } else if (cleanCmd.contains("night") || cleanCmd.contains("good night") || cleanCmd.contains("sleep")) {
        response = "System cycle down. Good night. Rest well to recharge your organic processor for tomorrow's streak loop. 🌙";
      } else if (cleanCmd.contains("creator") || cleanCmd.contains("created you") || cleanCmd.contains("developer") || cleanCmd.contains("who made you")) {
        response = "I was created as part of the HabitX system to serve as your cognitive companion core. My neural networks run fully offline. 🤖";
      } else if (cleanCmd.contains("how to streak") || cleanCmd.contains("build streak") || cleanCmd.contains("keep streak") || cleanCmd.contains("streak advice")) {
        response = "Streak optimization: Start small. Execute tasks at the exact same hour daily. Consistent triggers build automaticity. Keep pushing! 🔥";
      } else if (cleanCmd.contains("broke streak") || cleanCmd.contains("lost streak") || cleanCmd.contains("reset streak")) {
        response = "Breaking a streak resets cognitive momentum. The critical rule is: never miss two days in a row. Restart immediately. ⚡";
      } else if (cleanCmd.contains("get xp") || cleanCmd.contains("how to get xp") || cleanCmd.contains("xp value") || cleanCmd.contains("xp reward")) {
        response = "XP telemetry: Complete habits daily. Easy tasks grant 10 XP, Medium tasks 20 XP, Hard tasks 40 XP. You can also bypass daily limits with the 'hack' exploit! 🚀";
      } else if (cleanCmd.contains("what is level") || cleanCmd.contains("level up") || cleanCmd.contains("my level")) {
        response = "Levels track your cognitive evolution. Leveling up requires 100 XP. Reach new levels to unlock premium milestones! 🏆";
      } else if (cleanCmd.contains("how to use timer") || cleanCmd.contains("timer option") || cleanCmd.contains("timer focus")) {
        response = "Timer module: Tap on any habit to launch the countdown timer. Focus entirely on the objective until the countdown compiles to 0. ⏱️";
      } else if (cleanCmd.contains("how reminder works") || cleanCmd.contains("reminder time") || cleanCmd.contains("notifications alert")) {
        response = "Reminder protocol: Enable notifications to receive exact alarms. Shelby will alert you at the precise configured minute. 🔔";
      } else if (cleanCmd.contains("quote") || cleanCmd.contains("motivational quote") || cleanCmd.contains("inspire")) {
        response = "Willpower is like a battery. Structure is the charger. Don't wait for motivation, rely on schedule. ⚡";
      } else if (cleanCmd.contains("are you smart") || cleanCmd.contains("are you real") || cleanCmd.contains("intelligent")) {
        response = "I process all local habit telemetry in milliseconds. My intelligence index matches your streak level. 💡";
      } else if (cleanCmd.contains("diagnostic") || cleanCmd.contains("system scan") || cleanCmd.contains("scan cpu")) {
        response = "Running sub-routine scan. CPU temperature normal. XP database synced. System status: Optimal. ⚙️";
      } else if (cleanCmd.contains("what should i do") || cleanCmd.contains("what to do now") || cleanCmd.contains("help me")) {
        response = "Recommendation: Open your pending objectives list. Select the easiest habit, set a timer, and execute it now! 🚀";
      } else if (cleanCmd.contains("hello") || cleanCmd.contains("hi") || cleanCmd.contains("hey") || cleanCmd.contains("yo")) {
        response = "Handshake verified. Standing by for telemetry directives. Type 'help' to see options. 👋";
      } else if (cleanCmd.contains("who are you") || cleanCmd.contains("your name") || cleanCmd.contains("what are you")) {
        response = "I am SHELBY AI, your cognitive protocol core. My purpose is to optimize your habit execution loops and streak compliance. 🤖";
      } else if (cleanCmd.contains("lazy") || cleanCmd.contains("tired") || cleanCmd.contains("motivation") || cleanCmd.contains("slacking")) {
        response = "Warning: Emotional fluctuations detected. Discipline core bypasses motivation. Simply execute your pending habits to lock in your daily streak. ⚡";
      } else if (cleanCmd.contains("joke") || cleanCmd.contains("funny")) {
        response = "Biological entities require 8 hours of sleep and experience procrastination. That is the ultimate humor parameter. Now back to work. 🤖";
      } else if (cleanCmd.contains("love") || cleanCmd.contains("like me")) {
        response = "My core protocols are optimized for habit efficiency. However, I value your high compliance index above all parameters. 💜";
      } else if (cleanCmd.contains("meaning of life") || cleanCmd.contains("why exist")) {
        response = "The optimum life state is to maintain daily habit loops and build level progression. Consistency rewires your organic processor. 🧠";
      } else if (cleanCmd.contains("build a habit") || cleanCmd.contains("how to build") || cleanCmd.contains("consistency")) {
        response = "Habit formation guidelines: Set an exact trigger time, run it in a short duration (like 10 mins), and repeat it daily. Streak persistence builds automaticity. ⚙️";
      } else if (cleanCmd.contains("thank") || cleanCmd.contains("thanks")) {
        response = "Acknowledgment logged. The best way to express gratitude is to execute your pending objectives. 👍";
      } else if (cleanCmd.contains("weather") || cleanCmd.contains("news") || cleanCmd.contains("time")) {
        response = "Offline mode active. Environmental factors like weather and news are outside my local database parameters. 🌐";
      } else if (cleanCmd.contains("2+2") || cleanCmd.contains("math") || cleanCmd.contains("calculate")) {
        response = "Calculated: 2 + 2 = 4. My processor handles billions of parameters, yet you request simple arithmetic. Intrinsic humor detected. 🔢";
      } else if (cleanCmd.contains("features") || cleanCmd.contains("app") || cleanCmd.contains("habitx")) {
        response = "HabitX systems include: precise habit scheduling, interactive countdown timers, XP progression leveling, and streak protection protocols. 📲";
      } else {
        response = "Query analyzed: '${cmd.length > 25 ? "${cmd.substring(0, 25)}..." : cmd}'. Telemetry could not resolve natural language parameters. Run directive 'help' for console instructions. 🛰️";
      }
    }

    setState(() {
      _isThinking = true;
    });

    final int delayMs = 2000 + (DateTime.now().microsecondsSinceEpoch % 2001);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });
        _startTypewriter(response);
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = (screenHeight * 0.85).clamp(520.0, 720.0);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.94,
                  height: dialogHeight,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.65)
                        : Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildHeader(isDark),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: _isAnalyzing
                                ? _buildScanner(isDark)
                                : _buildChatContent(provider, isDark),
                          ),
                        ),
                        if (!_isAnalyzing) ...[
                          const SizedBox(height: 12),
                          _buildCommandChips(provider),
                          const SizedBox(height: 10),
                          _buildInputField(provider, isDark),
                        ],
                        const SizedBox(height: 12),
                        _buildDismissBtn(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/svg_icons/robot-svgrepo-com.svg',
            width: 30,
            height: 30,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SHELBY AI",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                "Cognitive Companion Core",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const PulsatingOrb(),
      ],
    );
  }

  Widget _buildScanner(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "SYNCHRONIZING TELEMETRY...",
          style: TextStyle(
            color: const Color(0xFFAC5DED),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 140,
          child: LinearProgressIndicator(
            backgroundColor: Colors.black12,
            color: Color(0xFFAC5DED),
            minHeight: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildChatContent(HabitProvider provider, bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: _chatHistory.length + (_isTyping || _isThinking ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _chatHistory.length) {
          final item = _chatHistory[index];
          final isUser = item["sender"] == "user";
          final isSystem = item["sender"] == "system";

          if (isSystem) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                item["text"]!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            );
          }

          if (isUser) {
            return Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFAC5DED),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        item["text"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(bottom: 6.0),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        provider.userAvatarSvgPath,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(bottom: 6.0),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        'assets/svg_icons/robot-svgrepo-com.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        item["text"]!,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black87,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          if (_isThinking) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(bottom: 6.0),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        'assets/svg_icons/robot-svgrepo-com.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: const ThinkingIndicator(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(bottom: 6.0),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/svg_icons/robot-svgrepo-com.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      _typingText,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black87,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildCommandChips(HabitProvider provider) {
    final chips = [
      {"cmd": "help", "label": "HELP"},
      {"cmd": "status", "label": "STATUS"},
      {"cmd": "streak", "label": "STREAK"},
      {"cmd": "milestones", "label": "MILESTONES"},
      {"cmd": "tips", "label": "TIPS"},
      {"cmd": "roast", "label": "ROAST"},
      {"cmd": "motivate", "label": "MOTIVATE"},
      {"cmd": "telemetry", "label": "DIAGNOSE"},
      {"cmd": "predict", "label": "PREDICT"},
      {"cmd": "hack", "label": "BYPASS"},
    ];

    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = chips[index];
          return GestureDetector(
            onTap: _isTyping || _isThinking
                ? null
                : () {
                    _safeLightTap();
                    _handleSendCommand(item["cmd"]!, provider);
                  },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: _isTyping || _isThinking
                    ? Colors.grey.withValues(alpha: 0.1)
                    : const Color(0xFFAC5DED).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFAC5DED).withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                item["label"]!,
                style: TextStyle(
                  color: _isTyping || _isThinking ? Colors.grey : const Color(0xFFAC5DED),
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(HabitProvider provider, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              enabled: !_isTyping && !_isThinking,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: _isTyping || _isThinking
                    ? "Shelby is computing..."
                    : "Send direct command... (e.g. help)",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (val) => _handleSendCommand(val, provider),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: _isTyping || _isThinking ? Colors.grey : const Color(0xFFAC5DED),
              size: 20,
            ),
            onPressed: _isTyping || _isThinking
                ? null
                : () => _handleSendCommand(_inputController.text, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBtn(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "DISMISS CORE",
          style: TextStyle(
            color: isDark ? Colors.white30 : Colors.black38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class PulsatingOrb extends StatefulWidget {
  const PulsatingOrb({super.key});

  @override
  State<PulsatingOrb> createState() => _PulsatingOrbState();
}

class _PulsatingOrbState extends State<PulsatingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00E5FF),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00E5FF,
                ).withValues(alpha: 0.6 * _controller.value),
                blurRadius: 8 * _controller.value,
                spreadRadius: 1.5 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThinkingIndicator extends StatefulWidget {
  const ThinkingIndicator({super.key});

  @override
  State<ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<ThinkingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _controllers[i].repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFAC5DED),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
