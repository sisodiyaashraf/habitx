import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';
import 'xp_header.dart';
import 'habit_list_view.dart';

class HomeTabletContent extends StatelessWidget {
  const HomeTabletContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider data to pass into XpHeader
    final provider = context.watch<HabitProvider>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar/Header on the left for Tablets
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: XpHeader(
              currentXp: provider.userXP, // Pass the required XP
              level: provider.userLevel,
              userName: provider.userName, // Pass the required Level
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        // Habit List on the right
        const Expanded(
          flex: 3,
          child: Padding(padding: EdgeInsets.all(16), child: HabitListView()),
        ),
      ],
    );
  }
}
