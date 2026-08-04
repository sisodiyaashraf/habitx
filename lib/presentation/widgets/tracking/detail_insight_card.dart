import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../domain/models/habit.dart';

class DetailInsightCard extends StatelessWidget {
  final Habit habit;
  final Color textColor;
  final Color subTextColor;
  final bool isDark;

  const DetailInsightCard({
    super.key,
    required this.habit,
    required this.textColor,
    required this.subTextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 125,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withValues(alpha: 0.12),
          const Color(0xFF00E5FF).withValues(alpha: 0.04),
        ],
      ),
      borderGradient: const LinearGradient(
        colors: [Color(0xFFAC5DED), Color(0xFF00E5FF)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "SHELBY AI INSIGHT",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "LIVE",
                          style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    habit.streak > 5
                        ? "Your consistency is above 90%. You're in the top 5% for this habit. Keep pushing!"
                        : "Establishing phase. Complete this habit for 3 consecutive days to build a solid neurological loop.",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
