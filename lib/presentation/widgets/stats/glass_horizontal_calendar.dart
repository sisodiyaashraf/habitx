import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';

class GlassHorizontalCalendar extends StatelessWidget {
  const GlassHorizontalCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Show two weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isToday = index == 3;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GlassmorphicContainer(
              width: 65,
              height: 90,
              borderRadius: 20,
              blur: 15,
              alignment: Alignment.center,
              border: isToday ? 2 : 1,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(isToday ? 0.2 : 0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderGradient: LinearGradient(
                colors: [
                  isToday ? const Color(0xFFAC5DED) : Colors.white24,
                  Colors.transparent,
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${date.day}",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
