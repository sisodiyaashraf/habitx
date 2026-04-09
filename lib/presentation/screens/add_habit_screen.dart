import 'package:flutter/material.dart';
import '../widgets/add_habit/add_habit_form.dart';
import '../widgets/shared/glass_background.dart'; // Using your optimized global background

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // The background now handles the orbs and blur globally
      body: GlassBackground(
        child: Column(
          children: [
            _buildCustomAppBar(context),
            Expanded(
              child: SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double horizontalPadding = constraints.maxWidth > 600
                        ? 120
                        : 20;

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 20,
                      ),
                      child: const AddHabitForm(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Floating back button with subtle gradient border
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFAC5DED).withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87, // High visibility
                  size: 18,
                ),
              ),
            ),
            const Text(
              'New Habit',
              style: TextStyle(
                color: Colors.black, // Onyx visibility
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            // Empty sized box to balance the Row
            const SizedBox(width: 42),
          ],
        ),
      ),
    );
  }
}
