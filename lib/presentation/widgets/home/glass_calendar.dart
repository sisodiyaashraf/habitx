import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/habit_provider.dart';

class GlassCalendar extends StatelessWidget {
  const GlassCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final selectedDate = habitProvider.selectedDate;

    return SizedBox(
      height: 110, // Increased height for better tap targets
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 14, // Show two weeks for better planning
        itemBuilder: (context, index) {
          // Logic to show dates around the current date
          DateTime date = DateTime.now().add(Duration(days: index - 3));
          bool isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => habitProvider.selectedDate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
              child: GlassmorphicContainer(
                width: 65,
                height: 95,
                borderRadius: 22,
                blur: 20,
                alignment: Alignment.center,
                border: isSelected ? 2 : 1.2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          Colors.white.withOpacity(0.4), // Whiter for selected
                          Colors.white.withOpacity(0.2),
                        ]
                      : [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.08),
                        ],
                ),
                borderGradient: LinearGradient(
                  colors: isSelected
                      ? [
                          const Color(0xFFAC5DED), // Brand Purple
                          const Color(0xFF7B61FF), // Accent Blue
                        ]
                      : [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.05),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date).toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFAC5DED)
                            : Colors.black54,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w700,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFAC5DED),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
