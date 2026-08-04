import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../../core/constants/notification_messages.dart';
import 'ai_bot/chat_bubble.dart';
import 'ai_bot/preset_suggestions.dart';
import 'ai_bot/ai_bot_logic.dart';
import 'ai_bot/ai_bot_dialog_widgets.dart';

export 'ai_bot/ai_bot_dialog_widgets.dart' show PulsatingOrb;

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
        setState(() => _isAnalyzing = false);
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

    String contextType = 'midday';
    if (total == 0) {
      contextType = 'empty';
    } else if (done == total) {
      contextType = 'celebration';
    } else if (progress < 0.5) {
      contextType = 'nudge';
    }

    final initialMsg = NotificationMessages.getInAppBriefing(
      persona: provider.activePersona,
      context: contextType,
      username: provider.userName,
      completed: done,
      total: total,
      streak: provider.allHabits.isNotEmpty
          ? provider.allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b)
          : 0,
    );

    _startTypewriter(initialMsg);
  }

  void _startTypewriter(String message) {
    if (mounted) setState(() { _isTyping = true; _typingText = ""; });

    int charIndex = 0;
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      try {
        if (charIndex < message.length) {
          if (mounted) {
            setState(() { _typingText += message[charIndex]; charIndex++; });
            if (message[charIndex - 1] == '\n' || charIndex % 15 == 0) _scrollToBottom();
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

    setState(() => _chatHistory.add({"sender": "user", "text": cmd}));
    _scrollToBottom();

    final response = AiBotLogic.processCommand(
      command: cmd,
      provider: provider,
      hasHackedToday: _hasHackedToday,
      onHackTriggered: () { _hasHackedToday = true; },
    );

    setState(() => _isThinking = true);

    final int delayMs = 2000 + (DateTime.now().microsecondsSinceEpoch % 2001);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        setState(() => _isThinking = false);
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
    final dialogHeight = (MediaQuery.of(context).size.height * 0.85).clamp(520.0, 720.0);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        AiBotHeader(isDark: isDark),
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
                                ? const AiBotScanner()
                                : _buildChatContent(provider, isDark),
                          ),
                        ),
                        if (!_isAnalyzing) ...[
                          const SizedBox(height: 12),
                          PresetSuggestions(
                            isTypingOrThinking: _isTyping || _isThinking,
                            onTapCommand: (cmd) => _handleSendCommand(cmd, provider),
                          ),
                          const SizedBox(height: 10),
                          AiBotInputField(
                            controller: _inputController,
                            isDisabled: _isTyping || _isThinking,
                            provider: provider,
                            isDark: isDark,
                            onSend: _handleSendCommand,
                          ),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
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
                        ),
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

  Widget _buildChatContent(HabitProvider provider, bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: _chatHistory.length + (_isTyping || _isThinking ? 1 : 0),
      itemBuilder: (context, index) {
        final item = index < _chatHistory.length ? _chatHistory[index] : null;
        return ChatBubble(
          item: item,
          isThinking: _isThinking,
          isTyping: _isTyping,
          typingText: _typingText,
          userAvatarSvgPath: provider.userAvatarSvgPath,
          isDark: isDark,
        );
      },
    );
  }
}
