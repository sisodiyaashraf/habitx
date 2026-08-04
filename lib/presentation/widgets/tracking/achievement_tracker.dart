import 'package:flutter/material.dart';
import '../../../core/constants/achievement_data.dart';
import '../../../providers/habit_provider.dart';
import 'achievement_badge.dart';

class AchievementTracker extends StatelessWidget {
  final HabitProvider provider;

  const AchievementTracker({super.key, required this.provider});

  static int getAchievementCount() => 11;

  static List<Map<String, dynamic>> getAchievementData(HabitProvider provider) {
    return AchievementData.getAchievementData(provider);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final achievementData = AchievementData.getAchievementData(provider);
    final unlockedCount = achievementData.where((data) => data['unlocked'] == true).length;
    final double unlockProgress = achievementData.isEmpty ? 0.0 : unlockedCount / achievementData.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sleek progress bar showing total achievement completion progress
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "UNLOCKED PROGRESS",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    "${(unlockProgress * 100).toInt()}% COMPLETE",
                    style: const TextStyle(
                      color: Color(0xFFAC5DED),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    height: 6,
                    width: MediaQuery.of(context).size.width * 0.9 * unlockProgress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAC5DED), Color(0xFFF368E0)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // The list of badges
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: achievementData
                .map((data) => AchievementBadge(
                      data: data,
                      isDark: isDark,
                      textColor: textColor,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
