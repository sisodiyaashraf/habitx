import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';

class EmptyHabitState extends StatelessWidget {
  const EmptyHabitState({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Fetch the real-time user name from the provider safely
    final userName = context.select<HabitProvider, String>((p) => p.userName);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassIllustration(),
            const SizedBox(height: 32),
            const Text(
              "NO HABITS YET",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0, // Onyx style uppercase spacing
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your journey to Level 100 starts with a single habit. Tap '+' below to begin your streak!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 2. Pass the fetched name to the action hint
            _buildActionHint(userName),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassIllustration() {
    return GlassmorphicContainer(
      width: 140,
      height: 140,
      borderRadius: 70,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withOpacity(0.5),
          const Color(0xFF7B61FF).withOpacity(0.2),
        ],
      ),
      child: const Icon(
        Icons.rocket_launch_rounded,
        size: 60,
        color: Color(0xFFAC5DED),
      ),
    );
  }

  Widget _buildActionHint(String userName) {
    // Fallback just in case the name is completely empty
    final String displayName = userName.isNotEmpty
        ? userName.toUpperCase()
        : "BUILDER";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFAC5DED).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_border_sharp,
            color: Color(0xFFAC5DED),
            size: 16,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "$displayName, LET'S CRUSH SOME GOALS!",
              style: const TextStyle(
                color: Color(0xFFAC5DED),
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
