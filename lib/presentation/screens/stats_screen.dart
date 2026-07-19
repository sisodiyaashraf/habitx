import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/habit_provider.dart';
import '../widgets/tracking/weekly_bar_chart.dart';
import '../widgets/tracking/elite_heatmap.dart';
import '../widgets/tracking/achievement_tracker.dart';
import '../widgets/shared/glass_background.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "ANALYTICS",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GlassBackground(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ELITE RANK CARD ---
                ElitePerformanceCard(provider: provider),
                const SizedBox(height: 24),

                // --- QUICK STATS ---
                _buildQuickStatsRow(provider, textColor, subTextColor, isDark),
                const SizedBox(height: 32),

                // --- CONSISTENCY CHART ---
                _buildSectionHeader("CONSISTENCY SCORE", "7-DAY", subTextColor),
                const SizedBox(height: 16),
                const WeeklyBarChart(),

                const SizedBox(height: 32),

                // --- ACHIEVEMENTS ---
                _buildSectionHeader(
                  "ELITE ACHIEVEMENTS",
                  "${_calculateUnlockedCount(provider)}/${AchievementTracker.getAchievementCount()}",
                  subTextColor,
                ),
                const SizedBox(height: 16),
                AchievementTracker(provider: provider),

                const SizedBox(height: 32),

                // --- HEATMAP ---
                _buildSectionHeader(
                  "ACTIVITY INTENSITY",
                  "SELECTABLE MATRIX",
                  subTextColor,
                ),
                const SizedBox(height: 16),
                const EliteHeatmap(),
              ],
            ),
          ),
        ),
      ),
    );
  }
} // CLOSE StatsScreen

class ElitePerformanceCard extends StatefulWidget {
  final HabitProvider provider;

  const ElitePerformanceCard({super.key, required this.provider});

  @override
  State<ElitePerformanceCard> createState() => _ElitePerformanceCardState();
}

class _ElitePerformanceCardState extends State<ElitePerformanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _getTierName(int level) {
    if (level < 5) return "Initiate Builder";
    if (level < 10) return "Bronze Builder";
    if (level < 15) return "Silver Builder";
    if (level < 20) return "Gold Builder";
    if (level < 25) return "Platinum Builder";
    if (level < 50) return "Elite Builder";
    return "Grandmaster Builder";
  }

  Color _getTierColor(int level) {
    if (level < 5) return const Color(0xFFAC5DED); // Purple
    if (level < 10) return const Color(0xFFFF7A00); // Bronze
    if (level < 15) return const Color(0xFFC0C0C0); // Silver
    if (level < 20) return const Color(0xFFFFD700); // Gold
    if (level < 25) return const Color(0xFFE5E4E2); // Platinum
    if (level < 50) return const Color(0xFF00E5FF); // Elite Teal
    return const Color(0xFFFF3D00); // Grandmaster Red/Orange
  }

  dynamic _getTierIcon(int level) {
    if (level < 10) return FontAwesomeIcons.rocket;
    if (level < 20) return FontAwesomeIcons.shieldHalved;
    if (level < 25) return FontAwesomeIcons.gem;
    if (level < 50) return FontAwesomeIcons.crown;
    return FontAwesomeIcons.trophy;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    final provider = widget.provider;
    final level = provider.userLevel;
    final xp = provider.userXP;
    final tierName = _getTierName(level);
    final tierColor = _getTierColor(level);
    final tierIcon = _getTierIcon(level);

    final double progress = (xp % 100) / 100;
    final int xpToNextLevel = 100 - (xp % 100);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => _showPerformanceReport(
        context,
        level,
        xp,
        progress,
        xpToNextLevel,
        tierName,
        tierColor,
        tierIcon,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 140,
            borderRadius: 25,
            blur: 20,
            alignment: Alignment.center,
            border: 1.5,
            linearGradient: LinearGradient(
              colors: [
                isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.3),
                isDark
                    ? Colors.white.withValues(alpha: 0.02)
                    : Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [tierColor.withValues(alpha: 0.6), Colors.white10],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          RotationTransition(
                            turns: _rotationController,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    tierColor,
                                    tierColor.withValues(alpha: 0.01),
                                    tierColor,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black87 : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tierColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: FaIcon(tierIcon, color: tierColor, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Level $level Builder",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: tierColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: tierColor.withValues(alpha: 0.6),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  tierName.toUpperCase(),
                                  style: TextStyle(
                                    color: tierColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: progress),
                        duration: const Duration(seconds: 2),
                        builder: (context, val, child) => Text(
                          "${(val * 100).toInt()}%",
                          style: TextStyle(
                            color: tierColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOutQuart,
                    builder: (context, val, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: val,
                          minHeight: 8,
                          backgroundColor: isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.05),
                          color: tierColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPerformanceReport(
    BuildContext context,
    int level,
    int totalXp,
    double progress,
    int xpToNextLevel,
    String tierName,
    Color tierColor,
    dynamic tierIcon,
  ) {
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
                    _buildStatRow("Current Level", "Level $level", tierColor),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      "Total Cumulative XP",
                      "$totalXp XP",
                      tierColor,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      "Next Rank Ascend",
                      "In $xpToNextLevel XP",
                      tierColor,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      "Status Diagnostics",
                      "OPTIMAL ⚡",
                      Colors.greenAccent,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _getMotivationQuote(level),
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

  Widget _buildStatRow(String label, String value, Color valueColor) {
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

  String _getMotivationQuote(int level) {
    if (level < 5) {
      return "Initiate: Your cognitive journey has begun. Small micro-wins lock in foundational habits.";
    }
    if (level < 10) {
      return "Bronze: Consistency patterns detected. Keep moving, you are forging elite neural loops.";
    }
    if (level < 15) {
      return "Silver: Discipline is overriding raw motivation. Your productivity dashboard is humming.";
    }
    if (level < 20) {
      return "Gold: Outstanding focus. Your execution frequency is far above average human standards.";
    }
    if (level < 25) {
      return "Platinum: Pure structure. You have engineered an efficient habit lifestyle.";
    }
    if (level < 50) {
      return "Elite: Master of routines. You operate with surgical precision and execution.";
    }
    return "Grandmaster: Legendary status. The absolute pinnacle of human scheduling and consistency.";
  }
}

Widget _buildQuickStatsRow(
  HabitProvider provider,
  Color textColor,
  Color subTextColor,
  bool isDark,
) {
  final int done = provider.allHabits.where((h) => h.isCompleted).length;
  final int total = provider.allHabits.length;
  final int maxStreak = provider.allHabits.isEmpty
      ? 0
      : provider.allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _statBox(
        "XP",
        "${provider.userXP}",
        FontAwesomeIcons.bolt,
        textColor,
        subTextColor,
        isDark,
      ),
      _statBox(
        "STREAK",
        "$maxStreak",
        FontAwesomeIcons.fire,
        textColor,
        subTextColor,
        isDark,
      ),
      _statBox(
        "DONE",
        "$done/$total",
        FontAwesomeIcons.checkDouble,
        textColor,
        subTextColor,
        isDark,
      ),
    ],
  );
}

// FIX: Icon type changed to dynamic to prevent FaIconData casting error
Widget _statBox(
  String label,
  String value,
  dynamic icon,
  Color textColor,
  Color subTextColor,
  bool isDark,
) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: subTextColor,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

int _calculateUnlockedCount(HabitProvider provider) {
  final achievements = AchievementTracker.getAchievementData(provider);
  return achievements.where((a) => a['unlocked'] as bool).length;
}

Widget _buildSectionHeader(String title, String trailing, Color subTextColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          color: subTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFAC5DED).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFFAC5DED),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ],
  );
}
