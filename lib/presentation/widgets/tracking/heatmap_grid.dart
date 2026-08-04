import 'package:flutter/material.dart';
import '../../../domain/models/habit.dart';
import 'heatmap_cell.dart';

class HeatmapGrid extends StatelessWidget {
  final Map<DateTime, num> dataMap;
  final int selectedDays;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDark;
  final DateTime? selectedCellDate;
  final void Function(DateTime date, num value) onCellSelected;

  const HeatmapGrid({
    super.key,
    required this.dataMap,
    required this.selectedDays,
    required this.startDate,
    required this.endDate,
    required this.isDark,
    required this.selectedCellDate,
    required this.onCellSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDays == 7) return _build7DayGridView();
    return _buildMultiDayGridView();
  }

  Widget _build7DayGridView() {
    final daysList = List.generate(7, (i) => startDate.add(Duration(days: i)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 14.0;
          final double cellWidth = (constraints.maxWidth - (spacing * 2)) / 3;
          final double cellHeight = (constraints.maxHeight - (spacing * 2)) / 3;
          double aspectRatio = (cellWidth / cellHeight).clamp(0.8, 1.8);
          if (aspectRatio.isNaN || aspectRatio.isInfinite) aspectRatio = 1.3;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemCount: daysList.length,
            itemBuilder: (context, index) {
              final date = daysList[index];
              final value = dataMap[DateTime(date.year, date.month, date.day)] ?? 0;
              return HeatmapCell(
                date: date,
                value: value,
                isSelected: selectedCellDate?.isSameDay(date) ?? false,
                isDark: isDark,
                onSelected: onCellSelected,
                showDayLabel: true,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMultiDayGridView() {
    final daysList = List.generate(selectedDays, (i) => startDate.add(Duration(days: i)));
    const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekdays.map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double spacing = selectedDays > 60 ? 6.0 : 8.0;
                final double cellWidth = (constraints.maxWidth - (spacing * 6)) / 7;
                final int rowCount = (selectedDays / 7.0).ceil();
                final double cellHeight = (constraints.maxHeight - (spacing * (rowCount - 1))) / rowCount;
                double aspectRatio = (cellWidth / cellHeight).clamp(0.65, 1.5);
                if (aspectRatio.isNaN || aspectRatio.isInfinite) aspectRatio = 1.0;

                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: daysList.length,
                  itemBuilder: (context, index) {
                    final date = daysList[index];
                    final value = dataMap[DateTime(date.year, date.month, date.day)] ?? 0;
                    return HeatmapCell(
                      date: date,
                      value: value,
                      isSelected: selectedCellDate?.isSameDay(date) ?? false,
                      isDark: isDark,
                      onSelected: onCellSelected,
                      fontSize: selectedDays > 60 ? 10 : 12,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
