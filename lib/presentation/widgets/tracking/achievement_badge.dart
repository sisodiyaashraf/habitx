import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementBadge extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final Color textColor;

  const AchievementBadge({
    super.key,
    required this.data,
    required this.isDark,
    required this.textColor,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final unlocked = data['unlocked'] as bool;
    final themeColor = data['color'] as Color;
    final isDark = widget.isDark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => _showAchievementDetails(context, data),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : (_isHovered ? 1.08 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 8),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (unlocked)
                      AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    GlassmorphicContainer(
                      width: 80,
                      height: 80,
                      borderRadius: 24,
                      blur: 12,
                      alignment: Alignment.center,
                      border: unlocked ? 2.0 : 1.0,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          unlocked
                              ? themeColor.withValues(alpha: 0.25)
                              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                          unlocked
                              ? themeColor.withValues(alpha: 0.05)
                              : (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.01)),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          unlocked ? themeColor : Colors.white24,
                          Colors.white10,
                        ],
                      ),
                      child: FaIcon(
                        unlocked ? data['icon'] : FontAwesomeIcons.lock,
                        color: unlocked
                            ? themeColor
                            : (isDark ? Colors.white24 : Colors.black26),
                        size: unlocked ? 32 : 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  data['label'].toString().toUpperCase(),
                  style: TextStyle(
                    color: unlocked ? widget.textColor : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context, Map<String, dynamic> data) {
    final unlocked = data['unlocked'] as bool;
    final themeColor = data['color'] as Color;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "AchievementDetail",
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 400,
              borderRadius: 32,
              blur: 24,
              border: 1.5,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
              borderGradient: LinearGradient(
                colors: [
                  unlocked ? themeColor : Colors.white24,
                  Colors.transparent,
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (unlocked)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.5),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: unlocked
                              ? themeColor.withValues(alpha: 0.15)
                              : Colors.white10,
                          child: FaIcon(
                            unlocked ? data['icon'] : FontAwesomeIcons.lock,
                            color: unlocked ? themeColor : Colors.white30,
                            size: 46,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      data['label'].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: unlocked
                            ? themeColor.withValues(alpha: 0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: unlocked ? themeColor.withValues(alpha: 0.3) : Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        unlocked ? "UNLOCKED" : "LOCKED",
                        style: TextStyle(
                          color: unlocked ? themeColor : Colors.white30,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      data['desc'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Criteria: ${data['m']}",
                      style: TextStyle(
                        color: unlocked ? themeColor.withValues(alpha: 0.8) : Colors.white30,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
