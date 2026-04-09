import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:ui';

class LevelUpOverlay extends StatelessWidget {
  final int newLevel;

  const LevelUpOverlay({super.key, required this.newLevel});

  static void show(BuildContext context, int level) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Level Up',
      barrierColor: Colors.black.withOpacity(
        0.2,
      ), // Lighter barrier for better glass look
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return Material(
          type: MaterialType.transparency,
          child: LevelUpOverlay(newLevel: level),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Full Screen Blur behind the card
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),

        Center(
          child: GlassmorphicContainer(
            width: 320,
            height: 400,
            borderRadius: 40,
            blur: 40,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.4), // Milky glass for Onyx text
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                const Color(0xFFAC5DED),
                const Color(0xFF7B61FF).withOpacity(0.5),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with subtle glow
                  _buildAnimatedIcon(),
                  const SizedBox(height: 30),

                  const Text(
                    "LEVEL UP!",
                    style: TextStyle(
                      color: Colors.black, // Onyx Visibility
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Ashraf, you reached Level $newLevel",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Your consistency is paying off. Keep crushing those habits!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45, fontSize: 13),
                  ),
                  const SizedBox(height: 40),

                  _buildAwesomeButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Color(0xFFAC5DED),
        size: 70,
      ),
    );
  }

  Widget _buildAwesomeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "AWESOME",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
