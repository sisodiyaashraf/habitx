import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptic Feedback
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // FA Icons
import 'ai_bot_dialog.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 33),
      child: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width,
        height: 85, // Slightly taller for better thumb reach
        borderRadius: 35,
        blur: 25,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
            isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withOpacity(0.5),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(context, FontAwesomeIcons.house, 0, isDark),
            _navItem(context, FontAwesomeIcons.chartLine, 1, isDark),

            // THE AI BOT: Enhanced central trigger
            _buildAiBotTrigger(context),

            _navItem(context, FontAwesomeIcons.clockRotateLeft, 2, isDark),
            _navItem(context, FontAwesomeIcons.solidUser, 3, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBotTrigger(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact(); // Tactical feedback
        AiBotDialog.show(context);
      },
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 1.0 + (0.05 * value), // Subtle breathing animation
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFAC5DED), const Color(0xFF7B61FF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const FaIcon(
                FontAwesomeIcons.robot,
                color: Colors.white,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(BuildContext context, dynamic icon, int index, bool isDark) {
    final bool isSelected = currentIndex == index;
    const Color activeColor = Color(0xFFAC5DED);
    final Color inactiveColor = isDark ? Colors.white38 : Colors.black38;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.2 : 1.0, // Scale up active icon
              child: FaIcon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            // Premium selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 14 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
