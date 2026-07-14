import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          "Telemetry shows 0 active habits. Discipline core is idle. Instruct me with '/help' to configure new telemetry routines, or configure one in the console.";
    } else if (progress < 0.5) {
      initialMsg =
          "Warning: Current compliance is ${(progress * 100).toInt()}%. Cognitive momentum is sub-optimal. I recommend immediate execution of your pending habits. Type '/help' for options.";
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
          "• /status    - Decrypt habit compliance status\n"
          "• /roast     - Sarcastic review of daily discipline metrics\n"
          "• /motivate  - Request logical motivational briefings\n"
          "• /telemetry - Run diagnostic scan on offline subsystems\n"
          "• /predict   - Project willpower and level outcomes\n"
          "• /hack      - Execute database bypass exploit (+15 XP)\n"
          "• /help      - Display this list of directives";
    } else {
      response =
          "Command not recognized. Type '/help' to list available system directives.";
    }

    _startTypewriter(response);
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
                                : _buildChatContent(isDark),
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

  Widget _buildChatContent(bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: _chatHistory.length + (_isTyping ? 1 : 0),
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

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFAC5DED)
                    : (isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                item["text"]!,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black87),
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.centerLeft,
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
          );
        }
      },
    );
  }

  Widget _buildCommandChips(HabitProvider provider) {
    final chips = [
      {"cmd": "/help", "label": "HELP"},
      {"cmd": "/status", "label": "STATUS"},
      {"cmd": "/roast", "label": "ROAST"},
      {"cmd": "/motivate", "label": "MOTIVATE"},
      {"cmd": "/telemetry", "label": "DIAGNOSE"},
      {"cmd": "/predict", "label": "PREDICT"},
      {"cmd": "/hack", "label": "BYPASS"},
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
            onTap: _isTyping
                ? null
                : () {
                    _safeLightTap();
                    _handleSendCommand(item["cmd"]!, provider);
                  },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: _isTyping
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
                  color: _isTyping ? Colors.grey : const Color(0xFFAC5DED),
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
              enabled: !_isTyping,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: _isTyping
                    ? "Shelby is computing..."
                    : "Send direct command... (e.g. /help)",
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
              color: _isTyping ? Colors.grey : const Color(0xFFAC5DED),
              size: 20,
            ),
            onPressed: _isTyping
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
