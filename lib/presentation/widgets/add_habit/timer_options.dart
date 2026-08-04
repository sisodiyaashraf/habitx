import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimerOptions extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final int selectedMinutes;
  final bool isCustomTimer;
  final TextEditingController customTimeController;
  final void Function(int) onMinutesChanged;
  final void Function(bool) onCustomTimerChanged;
  final Widget Function(
    TextEditingController controller,
    String hint,
    dynamic icon,
    bool isDark,
    Color textColor, {
    required bool isNumber,
  }) buildGlassTextField;

  const TimerOptions({
    super.key,
    required this.isDark,
    required this.textColor,
    required this.selectedMinutes,
    required this.isCustomTimer,
    required this.customTimeController,
    required this.onMinutesChanged,
    required this.onCustomTimerChanged,
    required this.buildGlassTextField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ...[10, 20, 30].map(
              (mins) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _choiceChip(
                    "$mins m",
                    !isCustomTimer && selectedMinutes == mins,
                    () {
                      onCustomTimerChanged(false);
                      onMinutesChanged(mins);
                      customTimeController.clear();
                    },
                    isDark,
                    textColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _choiceChip(
                "CUSTOM",
                isCustomTimer,
                () => onCustomTimerChanged(true),
                isDark,
                textColor,
              ),
            ),
          ],
        ),
        if (isCustomTimer)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: buildGlassTextField(
              customTimeController,
              "Minutes (e.g. 45)",
              FontAwesomeIcons.stopwatch,
              isDark,
              textColor,
              isNumber: true,
            ),
          ),
      ],
    );
  }

  Widget _choiceChip(
    String label,
    bool selected,
    VoidCallback onSelected,
    bool isDark,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFAC5DED)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
