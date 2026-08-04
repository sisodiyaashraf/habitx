import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/models/habit.dart';

class DetailProgressHeader extends StatelessWidget {
  final Habit habit;
  final Color textColor;

  const DetailProgressHeader({
    super.key,
    required this.habit,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                color: Colors.white10,
              ),
            ),
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
}
