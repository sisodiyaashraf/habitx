import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';

class PerformanceReportDialog {
  static void show(
    BuildContext context, {
    required int level,
    required int totalXp,
    required double progress,
    required int xpToNextLevel,
    required String tierName,
    required Color tierColor,
    required dynamic tierIcon,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PerformanceReport",
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.86,
              height: 430,
              borderRadius: 30,
              blur: 25,
              border: 1.5,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
              borderGradient: LinearGradient(
                colors: [tierColor, Colors.transparent],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: tierColor.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: tierColor.withValues(alpha: 0.15),
                          child: FaIcon(tierIcon, color: tierColor, size: 36),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "COGNITIVE PERFORMANCE REPORT",
                      style: TextStyle(
                        color: tierColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tierName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 20),
                    _statRow("Current Level", "Level $level", tierColor),
                    const SizedBox(height: 12),
                    _statRow("Total Cumulative XP", "$totalXp XP", tierColor),
                    const SizedBox(height: 12),
                    _statRow("Next Rank Ascend", "In $xpToNextLevel XP", tierColor),
                    const SizedBox(height: 12),
                    _statRow("Status Diagnostics", "OPTIMAL ⚡", Colors.greenAccent),
                    const SizedBox(height: 24),
                    Text(
                      _motivationQuote(level),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
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

  static Widget _statRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  static String _motivationQuote(int level) {
    if (level < 5) return "Initiate: Your cognitive journey has begun. Small micro-wins lock in foundational habits.";
    if (level < 10) return "Bronze: Consistency patterns detected. Keep moving, you are forging elite neural loops.";
    if (level < 15) return "Silver: Discipline is overriding raw motivation. Your productivity dashboard is humming.";
    if (level < 20) return "Gold: Outstanding focus. Your execution frequency is far above average human standards.";
    if (level < 25) return "Platinum: Pure structure. You have engineered an efficient habit lifestyle.";
    if (level < 50) return "Elite: Master of routines. You operate with surgical precision and execution.";
    return "Grandmaster: Legendary status. The absolute pinnacle of human scheduling and consistency.";
  }
}
