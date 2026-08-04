import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_bubble_widgets.dart';

export 'chat_bubble_widgets.dart' show ThinkingIndicator;

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic>? item;
  final bool isThinking;
  final bool isTyping;
  final String typingText;
  final String userAvatarSvgPath;
  final bool isDark;

  const ChatBubble({
    super.key,
    required this.item,
    required this.isThinking,
    required this.isTyping,
    required this.typingText,
    required this.userAvatarSvgPath,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      final isUser = item!["sender"] == "user";
      final isSystem = item!["sender"] == "system";

      if (isSystem) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            item!["text"]!,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        );
      }

      if (isUser) return _userBubble();
      return _shelbyBubble(item!["text"]!);
    } else {
      if (isThinking) return _shelbyBubbleShell(const ThinkingIndicator());
      return _shelbyBubble(typingText);
    }
  }

  Widget _userBubble() {
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
                item!["text"]!,
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
                userAvatarSvgPath,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shelbyBubble(String text) {
    return _shelbyBubbleShell(
      Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
          fontSize: 12.5,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _shelbyBubbleShell(Widget child) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const ShelbyAvatarIcon(),
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
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
