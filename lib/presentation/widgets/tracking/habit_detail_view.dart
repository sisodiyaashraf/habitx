import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../shared/glass_background.dart';
import '../../screens/habit_timer_screen.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;
  const HabitDetailView({super.key, required this.habit});

  Color _getDifficultyColor(HabitDifficulty diff) {
    switch (diff) {
      case HabitDifficulty.easy:
        return const Color(0xFF00E5FF);
      case HabitDifficulty.medium:
        return const Color(0xFFAC5DED);
      case HabitDifficulty.hard:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () => _showDeleteConfirmation(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GlassBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
          child: Column(
            children: [
              // --- Visual Progress Header ---
              _buildProgressHeader(textColor),
              const SizedBox(height: 32),

              // --- Main Stat Grid ---
              Row(
                children: [
                  _buildSmallStatCard(
                    "STREAK",
                    "${habit.streak} Days",
                    FontAwesomeIcons.fire,
                    isDark,
                    textColor,
                  ),
                  const SizedBox(width: 10),
                  _buildSmallStatCard(
                    "REWARD",
                    "+${habit.xpValue} XP",
                    FontAwesomeIcons.bolt,
                    isDark,
                    textColor,
                  ),
                  const SizedBox(width: 10),
                  _buildSmallStatCard(
                    "TIMER",
                    "${habit.timerDuration} Min",
                    FontAwesomeIcons.clock,
                    isDark,
                    textColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Performance Insights Card ---
              _buildInsightCard(isDark, textColor, subTextColor),
              const SizedBox(height: 24),

              // --- Visual Weekly History ---
              _buildWeeklyHistory(textColor, subTextColor, isDark),
              const SizedBox(height: 24),

              // --- Detail Rows ---
              _buildDetailRow(
                "DIFFICULTY",
                habit.difficulty.name.toUpperCase(),
                FontAwesomeIcons.layerGroup,
                isDark,
                textColor,
                customValueWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(habit.difficulty).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getDifficultyColor(habit.difficulty).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    habit.difficulty.name.toUpperCase(),
                    style: TextStyle(
                      color: _getDifficultyColor(habit.difficulty),
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                "CREATED ON",
                _formatDate(habit.createdAt),
                FontAwesomeIcons.calendarCheck,
                isDark,
                textColor,
              ),

              if (habit.reminderTime != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  "REMINDER AT",
                  TimeOfDay.fromDateTime(habit.reminderTime!).format(context),
                  FontAwesomeIcons.solidBell,
                  isDark,
                  textColor,
                ),
              ],

              const SizedBox(height: 48),

              // --- Action Button ---
              _buildActionToggleButton(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildProgressHeader(Color textColor) {
    final progress = habit.streak % 30;
    final currentMilestoneGroup = (habit.streak ~/ 30) + 1;
    final daysLeft = 30 - (habit.streak % 30);

    String milestoneText;
    if (habit.streak == 0) {
      milestoneText = "30 days to Milestone 1";
    } else if (progress == 0) {
      milestoneText = "Milestone $currentMilestoneGroup Achieved! \u2728";
    } else {
      milestoneText = "$daysLeft days left to Milestone $currentMilestoneGroup";
    }

    double progressValue = habit.streak == 0 ? 0.0 : (progress == 0 ? 1.0 : progress / 30.0);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glowing Ring
            Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // Background Static Track
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                color: Colors.white10,
              ),
            ),
            // Active Gradient Track
            SizedBox(
              width: 140,
              height: 140,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const SweepGradient(
                    startAngle: 0.0,
                    endAngle: 3.14 * 2,
                    stops: [0.0, 1.0],
                    center: Alignment.center,
                    colors: [
                      Color(0xFFAC5DED),
                      Color(0xFF00E5FF),
                    ],
                  ).createShader(rect);
                },
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
            // Icon
            const FaIcon(
              FontAwesomeIcons.gem,
              color: Color(0xFF00E5FF),
              size: 38,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          habit.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge(milestoneText.toUpperCase()),
            const SizedBox(width: 8),
            _buildFreezeBadge(habit.streakFreezesAvailable),
          ],
        ),
      ],
    );
  }

  Widget _buildFreezeBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.ac_unit_rounded,
            color: Color(0xFF00E5FF),
            size: 11,
          ),
          const SizedBox(width: 4),
          Text(
            "$count",
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(
    String label,
    String value,
    dynamic icon,
    bool isDark,
    Color textColor,
  ) {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 90,
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            isDark ? Colors.white10 : Colors.white24,
            Colors.transparent,
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withValues(alpha: 0.4),
            Colors.transparent,
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: const Color(0xFF00E5FF), size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(bool isDark, Color textColor, Color subTextColor) {
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

  Widget _buildWeeklyHistory(Color textColor, Color subTextColor, bool isDark) {
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return GlassmorphicContainer(
      width: double.infinity,
      height: 110,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 1.0,
      linearGradient: LinearGradient(
        colors: [
          isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "COMPLETION HISTORY",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "Last 7 Days",
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(last7Days.length, (index) {
                final date = last7Days[index];
                final isCompletedOnDay = habit.completedDates.any(
                  (d) => d.year == date.year && d.month == date.month && d.day == date.day
                ) || (date.year == now.year && date.month == now.month && date.day == now.day && habit.isCompleted);

                final isFrozenOnDay = habit.frozenDates.any(
                  (d) => d.year == date.year && d.month == date.month && d.day == date.day
                );

                final dayLabel = weekdays[date.weekday - 1];
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

                return Column(
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        color: isToday ? const Color(0xFFAC5DED) : subTextColor,
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isCompletedOnDay
                            ? const LinearGradient(
                                colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                              )
                            : (isFrozenOnDay
                                ? const LinearGradient(
                                    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                                  )
                                : null),
                        color: (isCompletedOnDay || isFrozenOnDay) ? null : (isDark ? Colors.white12 : Colors.black12),
                        border: isToday
                            ? Border.all(
                                color: const Color(0xFF00E5FF),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: isCompletedOnDay
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : (isFrozenOnDay
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : []),
                      ),
                      child: Icon(
                        isCompletedOnDay
                            ? Icons.check
                            : (isFrozenOnDay ? Icons.ac_unit_rounded : Icons.close),
                        size: 12,
                        color: (isCompletedOnDay || isFrozenOnDay) ? Colors.white : (isDark ? Colors.white30 : Colors.black38),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    dynamic icon,
    bool isDark,
    Color textColor, {
    Widget? customValueWidget,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
      ),
      borderGradient: LinearGradient(
        colors: [isDark ? Colors.white10 : Colors.black12, Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(icon, color: const Color(0xFFAC5DED), size: 14),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            customValueWidget ??
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionToggleButton(BuildContext context, bool isDark) {
    final isCompleted = habit.isCompleted;
    final provider = context.watch<HabitProvider>();
    final canFreeze = provider.canFreezeHabit(habit);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isCompleted
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
                  ),
            boxShadow: isCompleted
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFFAC5DED).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: isCompleted
                    ? BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5)
                    : BorderSide.none,
              ),
            ),
            onPressed: () {
              if (isCompleted) {
                context.read<HabitProvider>().toggleHabitCompletion(
                  context,
                  habit.id,
                );
                Navigator.pop(context);
              } else {
                context.read<HabitProvider>().startTaskTimer(
                  habit.id,
                  habit.timerDuration,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitTimerScreen(
                      habitName: habit.name,
                      initialMinutes: habit.timerDuration,
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCompleted ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isCompleted ? "MARK AS INCOMPLETE" : "COMPLETE HABIT TASK",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canFreeze) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                foregroundColor: const Color(0xFF00E5FF),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                ),
              ),
              onPressed: () => _showFreezeConfirmation(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.ac_unit_rounded,
                    color: Color(0xFF00E5FF),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "FREEZE TODAY'S STREAK",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFAC5DED).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAC5DED).withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFAC5DED),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  void _showFreezeConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 240,
              borderRadius: 30,
              blur: 20,
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderGradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Colors.white24],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.ac_unit_rounded,
                      color: Color(0xFF00E5FF),
                      size: 40,
                    ),
                    Text(
                      "STREAK FREEZE",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Use your streak freeze for today? This protects your streak without modifying completions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dialogSubTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: dialogSubTextColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<HabitProvider>().useStreakFreeze(context, habit.id);
                            Navigator.pop(dialogContext); // close dialog
                            Navigator.pop(context); // return to tracking screen
                          },
                          child: const Text(
                            "FREEZE DAY",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogTextColor = isDark ? Colors.white : Colors.black;
        final dialogSubTextColor = isDark ? Colors.white70 : Colors.black54;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 240,
              borderRadius: 30,
              blur: 20,
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderGradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.white24],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    Text(
                      "DELETE HABIT",
                      style: TextStyle(
                        color: dialogTextColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "This action cannot be undone. All streak and completion data will be permanently wiped.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dialogSubTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: dialogSubTextColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            context.read<HabitProvider>().deleteHabit(habit.id);
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // return to tracking screen
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
