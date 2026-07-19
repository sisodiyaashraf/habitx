import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../providers/habit_provider.dart';

class AchievementTracker extends StatelessWidget {
  final HabitProvider provider;

  const AchievementTracker({super.key, required this.provider});

  static List<Map<String, dynamic>> getAchievementData(HabitProvider provider) {
    final habits = provider.allHabits;
    final int totalCompletions = habits.fold(0, (sum, h) => sum + h.completedDates.length);
    final int maxStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    final int userLevel = provider.userLevel;

    return [
      {
        "id": "initiate",
        "icon": FontAwesomeIcons.rocket,
        "label": "Initiate",
        "unlocked": totalCompletions >= 1,
        "m": "1 Habit Completed",
        "desc": "Take the first step on your epic productivity journey by completing your first habit.",
        "color": const Color(0xFFAC5DED),
      },
      {
        "id": "momentum",
        "icon": FontAwesomeIcons.fire,
        "label": "Momentum",
        "unlocked": maxStreak >= 3,
        "m": "3 Day Streak",
        "desc": "Stoke the fire. Maintain a streak of 3 days on any habit.",
        "color": const Color(0xFFFF5722),
      },
      {
        "id": "focus",
        "icon": FontAwesomeIcons.brain,
        "label": "Deep Focus",
        "unlocked": maxStreak >= 7,
        "m": "7 Day Streak",
        "desc": "Lock it in. Complete any habit 7 days in a row.",
        "color": const Color(0xFF2196F3),
      },
      {
        "id": "unstoppable",
        "icon": FontAwesomeIcons.bolt,
        "label": "Unstoppable",
        "unlocked": maxStreak >= 14,
        "m": "14 Day Streak",
        "desc": "Pure willpower. Maintain a 14-day streak on any habit.",
        "color": const Color(0xFFFFC107),
      },
      {
        "id": "consistency_guru",
        "icon": FontAwesomeIcons.infinity,
        "label": "Consistency Guru",
        "unlocked": maxStreak >= 30,
        "m": "30 Day Streak",
        "desc": "Habit mastery achieved! Run a streak for 30 consecutive days.",
        "color": const Color(0xFFE91E63),
      },
      {
        "id": "guardian",
        "icon": FontAwesomeIcons.shieldHalved,
        "label": "Guardian",
        "unlocked": totalCompletions >= 50,
        "m": "50 Completed",
        "desc": "A protector of habits. Accumulate 50 habit completions over time.",
        "color": const Color(0xFF4CAF50),
      },
      {
        "id": "centurion",
        "icon": FontAwesomeIcons.shield,
        "label": "Centurion",
        "unlocked": totalCompletions >= 100,
        "m": "100 Completed",
        "desc": "A legendary milestone. Accumulate 100 total habit completions.",
        "color": const Color(0xFF00BCD4),
      },
      {
        "id": "diamond",
        "icon": FontAwesomeIcons.gem,
        "label": "Diamond",
        "unlocked": totalCompletions >= 250,
        "m": "250 Completed",
        "desc": "Solid as a diamond. Accumulate 250 total habit completions.",
        "color": const Color(0xFF9C27B0),
      },
      {
        "id": "level_10",
        "icon": FontAwesomeIcons.star,
        "label": "Decathlon",
        "unlocked": userLevel >= 10,
        "m": "Level 10 Reached",
        "desc": "Rise through the ranks. Reach Level 10 on your profile.",
        "color": const Color(0xFFFF9800),
      },
      {
        "id": "elite_king",
        "icon": FontAwesomeIcons.crown,
        "label": "Elite King",
        "unlocked": userLevel >= 25,
        "m": "Level 25 Reached",
        "desc": "True dominance. Reach Level 25 and rule the daily streaks.",
        "color": const Color(0xFFFFEB3B),
      },
      {
        "id": "grandmaster",
        "icon": FontAwesomeIcons.trophy,
        "label": "Grandmaster",
        "unlocked": userLevel >= 50,
        "m": "Level 50 Reached",
        "desc": "A god amongst mortals. Reach the legendary Level 50.",
        "color": const Color(0xFFFF3D00),
      },
    ];
  }

  static int getAchievementCount() => 11;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final achievementData = getAchievementData(provider);
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
                .map((data) => _AchievementBadge(
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

class _AchievementBadge extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final Color textColor;

  const _AchievementBadge({
    required this.data,
    required this.isDark,
    required this.textColor,
  });

  @override
  State<_AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<_AchievementBadge> {
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
