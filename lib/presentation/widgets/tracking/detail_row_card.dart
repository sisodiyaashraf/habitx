import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';

class DetailRowCard extends StatelessWidget {
  final String label;
  final String value;
  final dynamic icon;
  final bool isDark;
  final Color textColor;
  final Widget? customValueWidget;

  const DetailRowCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.textColor,
    this.customValueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
      ),
      borderGradient: LinearGradient(
        colors: [isDark ? Colors.white10 : Colors.black12, Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, color: const Color(0xFFAC5DED), size: 14),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            customValueWidget ??
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
