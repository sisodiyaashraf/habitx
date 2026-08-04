import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PresetSuggestions extends StatelessWidget {
  final ValueChanged<String> onTapCommand;
  final bool isTypingOrThinking;

  const PresetSuggestions({
    super.key,
    required this.onTapCommand,
    required this.isTypingOrThinking,
  });

  void _safeLightTap() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: isTypingOrThinking
                ? null
                : () {
                    _safeLightTap();
                    onTapCommand(item["cmd"]!);
                  },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isTypingOrThinking
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
                  color: isTypingOrThinking ? Colors.grey : const Color(0xFFAC5DED),
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
}
