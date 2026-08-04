import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../domain/models/habit.dart';

class AchievementOverlayHelper {
  static void showEliteUnlockDialog(
    BuildContext context,
    String title,
    dynamic icon,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Achievement",
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, anim1, anim2) => Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 420,
          borderRadius: 40,
          blur: 30,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderGradient: const LinearGradient(
            colors: [Color(0xFFAC5DED), Colors.transparent],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGlowingIcon(icon),
              const SizedBox(height: 40),
              const Text(
                "MISSION ACCOMPLISHED",
                style: TextStyle(
                  color: Color(0xFFAC5DED),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC5DED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "RECEIVE REWARD",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildGlowingIcon(dynamic icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFAC5DED).withValues(alpha: 0.6),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        FaIcon(icon, color: Colors.white, size: 50),
      ],
    );
  }

  static void showStackedNudge({
    required BuildContext context,
    required Habit stackedHabit,
    required VoidCallback onComplete,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        content: GlassmorphicContainer(
          width: double.infinity,
          height: 70,
          borderRadius: 20,
          blur: 15,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              const Color(0xFFAC5DED).withValues(alpha: 0.2),
              const Color(0xFF00E5FF).withValues(alpha: 0.1),
            ],
          ),
          borderGradient: const LinearGradient(
            colors: [Color(0xFFAC5DED), Color(0xFF00E5FF)],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.link_rounded, color: Color(0xFF00E5FF), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "HABIT STACK TRIGGERED",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Ready for ${stackedHabit.name}?",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFAC5DED).withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    onComplete();
                    messenger.hideCurrentSnackBar();
                  },
                  child: const Text(
                    "COMPLETE",
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
