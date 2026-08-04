import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReminderToggle extends StatelessWidget {
  final bool isReminderEnabled;
  final bool isDark;
  final Color textColor;
  final ValueChanged<bool> onChanged;

  const ReminderToggle({
    super.key,
    required this.isReminderEnabled,
    required this.isDark,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                FaIcon(
                  isReminderEnabled
                      ? FontAwesomeIcons.solidBell
                      : FontAwesomeIcons.solidBellSlash,
                  color: const Color(0xFFAC5DED),
                  size: 18,
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Text(
                    "SET REMINDER",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isReminderEnabled,
            activeThumbColor: const Color(0xFFAC5DED),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
