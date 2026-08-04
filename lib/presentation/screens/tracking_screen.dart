import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/glass_background.dart';
import '../widgets/tracking/progress_item_tile.dart';
import '../widgets/tracking/habit_detail_view.dart';
import '../widgets/tracking/live_focus_monitor.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

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
          'ACTIVITY TRACKING',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSummary(provider, textColor, subTextColor, isDark),
              const SizedBox(height: 32),

              LiveFocusMonitor(
                provider: provider,
                textColor: textColor,
                subTextColor: subTextColor,
                isDark: isDark,
              ),

              const SizedBox(height: 32),
              Text(
                "HABIT BREAKDOWN",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "Real-time progress and habit depth",
                style: TextStyle(color: subTextColor, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ...provider.allHabits.map(
                (habit) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HabitDetailView(habit: habit),
                      fullscreenDialog: true,
                    ),
                  ),
                  child: ProgressItemTile(
                    habit: habit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(
    HabitProvider provider,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    final double completionRate = provider.allHabits.isEmpty
        ? 0
        : (provider.allHabits.where((h) => h.isCompleted).length /
                  provider.allHabits.length) *
              100;
    return Row(
      children: [
        _buildStatCard(
          "Current Level",
          "LVL ${provider.userLevel}",
          FontAwesomeIcons.rankingStar,
          textColor,
          subTextColor,
          isDark,
          const Color(0xFFAC5DED),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          "Success Rate",
          "${completionRate.toStringAsFixed(0)}%",
          FontAwesomeIcons.circleCheck,
          textColor,
          subTextColor,
          isDark,
          const Color(0xFF00E5FF),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    dynamic icon,
    Color textColor,
    Color subTextColor,
    bool isDark,
    Color accentColor,
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 85,
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.25),
            isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.08),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.4),
            Colors.white.withValues(alpha: 0.15),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    FaIcon(icon, color: accentColor, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5,
                              shadows: isDark
                                  ? [
                                      Shadow(
                                        color: accentColor.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                      )
                                    ]
                                  : [],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
