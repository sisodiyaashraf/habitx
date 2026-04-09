import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import '../../screens/stats_screen.dart';

class AiBotDialog extends StatefulWidget {
  const AiBotDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (context) => const AiBotDialog(),
    );
  }

  @override
  State<AiBotDialog> createState() => _AiBotDialogState();
}

class _AiBotDialogState extends State<AiBotDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glitchController;

  String _displayedText = "";
  int _charIndex = 0;
  late String _fullMessage;
  late List<Map<String, dynamic>> _suggestedActions;
  Timer? _typewriterTimer;

  bool _isAnalyzing = true;
  double _analysisProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _processShelbyIntelligence();
  }

  void _processShelbyIntelligence() {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    final total = provider.allHabits.length;
    final done = provider.allHabits.where((h) => h.isCompleted).length;
    final double progress = total == 0 ? 0 : done / total;

    // --- SHELBY Logic: Mission Directives ---
    if (total == 0) {
      _fullMessage =
          "> Initializing SHELBY v4.0...\n> User: Ashraf [Elite Dev]\n> Status: IDLE.\n> Directive: No active missions detected. Initialize habit telemetry to begin.";
      _suggestedActions = [
        {"icon": Icons.add_moderator, "label": "INIT HABIT", "type": "close"},
      ];
    } else if (progress < 0.5) {
      _fullMessage =
          "> Warning: Cognitive load imbalance.\n> Momentum: SUB-OPTIMAL.\n> Recommendation: Execute a focus strike mission immediately.";
      _suggestedActions = [
        {
          "icon": Icons.bolt,
          "label": "10m SPRINT",
          "value": 10,
          "type": "timer",
        },
        {
          "icon": Icons.shutter_speed,
          "label": "50m DEEP",
          "value": 50,
          "type": "timer",
        },
        {"icon": Icons.auto_graph, "label": "XP REPORT", "type": "stats"},
      ];
    } else {
      _fullMessage =
          "> Status: OPTIMAL.\n> Data shows high streak integrity.\n> Strategy: Secure remaining $done/$total objectives to maximize daily XP.";
      _suggestedActions = [
        {"icon": Icons.auto_graph, "label": "XP REPORT", "type": "stats"},
        {"icon": Icons.history_edu, "label": "LOGS", "type": "deep_dive"},
      ];
    }

    _simulateNeuralScan();
  }

  void _simulateNeuralScan() {
    if (mounted)
      setState(() {
        _isAnalyzing = true;
        _analysisProgress = 0.0;
      });
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_analysisProgress < 1.0) {
        if (mounted) setState(() => _analysisProgress += 0.05);
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _isAnalyzing = false);
          _startTypewriter();
        }
      }
    });
  }

  void _startTypewriter() {
    if (mounted)
      setState(() {
        _displayedText = "";
        _charIndex = 0;
      });
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 15), (
      timer,
    ) {
      if (_charIndex < _fullMessage.length) {
        if (mounted) {
          setState(() {
            _displayedText += _fullMessage[_charIndex];
            _charIndex++;
          });
          if (_charIndex % 3 == 0) HapticFeedback.selectionClick();
        }
      } else {
        _typewriterTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glitchController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final done = provider.allHabits.where((h) => h.isCompleted).length;
    final total = provider.allHabits.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Center(
      child: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width * 0.94,
        height: 600,
        borderRadius: 20,
        blur: 45,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED),
            const Color(0xFF00E5FF).withOpacity(0.5),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildShelbyHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFAC5DED).withOpacity(0.25),
                    ),
                  ),
                  child: _isAnalyzing
                      ? _buildScanner()
                      : _buildTerminalOutput(),
                ),
              ),
              const SizedBox(height: 15),
              if (!_isAnalyzing) _buildTacticalOptions(provider),
              const SizedBox(height: 15),
              _buildSystemStatus(progress),
              const SizedBox(height: 15),
              _buildDismissBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTacticalOptions(HabitProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "DIRECTIVES",
          style: TextStyle(
            color: Color(0xFFAC5DED),
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestedActions.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final action = _suggestedActions[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  if (action['type'] == 'timer') {
                    provider.setAiTimer(action['value']);
                    Navigator.pop(context);
                  } else if (action['type'] == 'stats') {
                    setState(() {
                      int t = provider.allHabits.length;
                      int d = provider.allHabits
                          .where((h) => h.isCompleted)
                          .length;
                      _fullMessage =
                          "> DECRYPTING XP...\n> Total XP: ${provider.userXP}\n> Level: ${provider.userLevel}\n> Accuracy: ${t == 0 ? 0 : (d / t * 100).toInt()}%\n\n> OPEN ANALYTICS CORE?";
                      _suggestedActions = [
                        {
                          "icon": Icons.analytics,
                          "label": "DEEP DIVE",
                          "type": "deep_dive",
                        },
                        {"icon": Icons.close, "label": "EXIT", "type": "close"},
                      ];
                    });
                    _simulateNeuralScan();
                  } else if (action['type'] == 'deep_dive') {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatsScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 95,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAC5DED).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFAC5DED).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        color: const Color(0xFF00E5FF),
                        size: 20,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        action['label'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScanner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _glitchController,
          builder: (context, child) => Text(
            "SYNCHRONIZING TELEMETRY...",
            style: TextStyle(
              color: _glitchController.value > 0.5
                  ? const Color(0xFF00E5FF)
                  : const Color(0xFFAC5DED),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 25),
        LinearProgressIndicator(
          value: _analysisProgress,
          backgroundColor: Colors.white10,
          color: const Color(0xFFAC5DED),
          minHeight: 2,
        ),
      ],
    );
  }

  Widget _buildTerminalOutput() {
    return SingleChildScrollView(
      child: Text(
        _displayedText,
        style: const TextStyle(
          color: Color(0xFF00E5FF),
          fontSize: 13,
          fontFamily: 'monospace',
          height: 1.5,
          shadows: [Shadow(color: Color(0xFF00E5FF), blurRadius: 2)],
        ),
      ),
    );
  }

  Widget _buildShelbyHeader() {
    return Row(
      children: [
        const FaIcon(FontAwesomeIcons.atom, color: Color(0xFF00E5FF), size: 22),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SHELBY AI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              "ADVANCED COGNITIVE ENGINE",
              style: TextStyle(
                color: Color(0xFFAC5DED),
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildEncryptionBadge(),
      ],
    );
  }

  Widget _buildEncryptionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Color(0xFF00E5FF), size: 10),
          SizedBox(width: 5),
          Text(
            "AES-256",
            style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatus(double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "LOCAL SYNC: ACTIVE",
          style: TextStyle(
            color: Colors.white24,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "CORE: ${(progress * 100).toInt()}%",
          style: const TextStyle(
            color: Color(0xFFAC5DED),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildDismissBtn() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "CLOSE INTERFACE",
          style: TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
