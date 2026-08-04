import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../providers/habit_provider.dart';

/// Pulsating teal status orb shown in the AI dialog header.
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
                color: const Color(0xFF00E5FF).withValues(alpha: 0.6 * _controller.value),
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

/// SHELBY AI dialog header row.
class AiBotHeader extends StatelessWidget {
  final bool isDark;
  const AiBotHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
}

/// Neural scan progress indicator shown while initializing.
class AiBotScanner extends StatelessWidget {
  const AiBotScanner({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Text input field + send button for user commands.
class AiBotInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDisabled;
  final HabitProvider provider;
  final bool isDark;
  final void Function(String, HabitProvider) onSend;

  const AiBotInputField({
    super.key,
    required this.controller,
    required this.isDisabled,
    required this.provider,
    required this.isDark,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
              enabled: !isDisabled,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: isDisabled
                    ? "Shelby is computing..."
                    : "Send direct command... (e.g. help)",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (val) => onSend(val, provider),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: isDisabled ? Colors.grey : const Color(0xFFAC5DED),
              size: 20,
            ),
            onPressed: isDisabled ? null : () => onSend(controller.text, provider),
          ),
        ],
      ),
    );
  }
}
