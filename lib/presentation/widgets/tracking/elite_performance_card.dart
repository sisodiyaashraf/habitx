import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../providers/habit_provider.dart';
import 'performance_report_dialog.dart';

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
    PerformanceReportDialog.show(
      context,
      level: level,
      totalXp: totalXp,
      progress: progress,
      xpToNextLevel: xpToNextLevel,
      tierName: tierName,
      tierColor: tierColor,
      tierIcon: tierIcon,
    );
  }
}

