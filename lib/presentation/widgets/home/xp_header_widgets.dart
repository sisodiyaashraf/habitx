import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XpHeaderWidgets {
  static Widget userText(String userName, int level, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            _getGreeting(userName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Level $level",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }

  static Widget levelBadge(bool isDark, double flashValue) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.lerp(
          const Color.fromARGB(255, 193, 100, 250),
          const Color.fromARGB(255, 164, 29, 243),
          flashValue,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: flashValue * 0.8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: const Color(0xFF007BFF).withValues(alpha: 0.4),
            blurRadius: 15,
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/svg_icons/lightning-flash-svgrepo-com.svg',
        width: 36 + (flashValue * 6),
        height: 36 + (flashValue * 10),
      ),
    );
  }

  static Widget progressSection(
    double progress,
    bool isDark,
    int xpToNextLevel,
    Color subTextColor,
    double flashValue,
  ) {
    return Column(
      children: [
        progressBar(progress, isDark, flashValue),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ASCENDING IN $xpToNextLevel XP",
              style: TextStyle(
                color: subTextColor,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(
                color: Color(0xFFAC5DED),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget progressBar(double progress, bool isDark, double flashValue) {
    return Stack(
      children: [
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 12,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFAC5DED),
                    Color.lerp(
                      const Color(0xFF7B61FF),
                      const Color(0xFF00E5FF),
                      flashValue,
                    )!,
                    const Color(0xFFAC5DED),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.5),
                    blurRadius: 10 + (flashValue * 10),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  static String _getGreeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING, ${name.toUpperCase()}";
    if (hour < 17) return "GOOD AFTERNOON, ${name.toUpperCase()}";
    return "GOOD EVENING, ${name.toUpperCase()}";
  }
}
