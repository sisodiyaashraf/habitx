import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconSelectorSheet extends StatefulWidget {
  final String selectedPresetName;
  final Function(String name, dynamic icon) onPresetSelected;
  final bool isDark;
  final Color textColor;

  const IconSelectorSheet({
    super.key,
    required this.selectedPresetName,
    required this.onPresetSelected,
    required this.isDark,
    required this.textColor,
  });

  @override
  State<IconSelectorSheet> createState() => _IconSelectorSheetState();
}

class _IconSelectorSheetState extends State<IconSelectorSheet> {
  final Map<String, List<Map<String, dynamic>>> _habitLibrary = {
    "Popular": [
      {"name": "Coding", "icon": FontAwesomeIcons.code},
      {"name": "Reading", "icon": FontAwesomeIcons.bookOpen},
      {"name": "Gym", "icon": FontAwesomeIcons.dumbbell},
      {"name": "Meditation", "icon": FontAwesomeIcons.brain},
      {"name": "Running", "icon": FontAwesomeIcons.personRunning},
      {"name": "Yoga", "icon": FontAwesomeIcons.spa},
    ],
    "Health": [
      {"name": "Drink Water", "icon": FontAwesomeIcons.droplet},
      {"name": "Morning Walk", "icon": FontAwesomeIcons.personWalking},
      {"name": "Healthy Meal", "icon": FontAwesomeIcons.appleWhole},
      {"name": "Skin Care", "icon": FontAwesomeIcons.faceGrinSquint},
      {"name": "Bath/Shower", "icon": FontAwesomeIcons.bath},
      {"name": "Sleep Well", "icon": FontAwesomeIcons.moon},
      {"name": "No Sugar", "icon": FontAwesomeIcons.ban},
    ],
    "Productivity": [
      {"name": "Deep Work", "icon": FontAwesomeIcons.laptopCode},
      {"name": "Journaling", "icon": FontAwesomeIcons.penNib},
      {"name": "Planning", "icon": FontAwesomeIcons.calendarCheck},
      {"name": "Learning", "icon": FontAwesomeIcons.graduationCap},
      {"name": "Inbox Zero", "icon": FontAwesomeIcons.inbox},
      {"name": "Review Day", "icon": FontAwesomeIcons.clipboardCheck},
    ],
    "Self-Care": [
      {"name": "Stretching", "icon": FontAwesomeIcons.childReaching},
      {"name": "Nap", "icon": FontAwesomeIcons.bed},
      {"name": "Music", "icon": FontAwesomeIcons.music},
      {"name": "Prayer", "icon": FontAwesomeIcons.handsPraying},
      {"name": "Quiet Time", "icon": FontAwesomeIcons.book},
      {"name": "Nature Walk", "icon": FontAwesomeIcons.tree},
    ],
    "Skills": [
      {"name": "Design", "icon": FontAwesomeIcons.palette},
      {"name": "Writing", "icon": FontAwesomeIcons.pen},
      {"name": "Language", "icon": FontAwesomeIcons.language},
      {"name": "Gaming", "icon": FontAwesomeIcons.gamepad},
      {"name": "Speaking", "icon": FontAwesomeIcons.microphone},
      {"name": "Marketing", "icon": FontAwesomeIcons.chartLine},
    ],
    "Finance": [
      {"name": "Save Money", "icon": FontAwesomeIcons.piggyBank},
      {"name": "Track Spend", "icon": FontAwesomeIcons.wallet},
      {"name": "Investments", "icon": FontAwesomeIcons.chartPie},
      {"name": "Budgeting", "icon": FontAwesomeIcons.moneyBillWave},
    ],
  };

  String _selectedCategory = "Popular";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySelector(widget.isDark),
        const SizedBox(height: 12),
        _buildPresetGrid(widget.isDark, widget.textColor),
      ],
    );
  }

  Widget _buildCategorySelector(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _habitLibrary.keys.map((cat) {
        bool isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFAC5DED)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.03)),
              borderRadius: BorderRadius.circular(15),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFAC5DED).withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              cat.toUpperCase(),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black54),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPresetGrid(bool isDark, Color textColor) {
    final presets = _habitLibrary[_selectedCategory]!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((item) {
        bool isPicked = widget.selectedPresetName == item['name'];
        return GestureDetector(
          onTap: () => widget.onPresetSelected(item['name'], item['icon']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isPicked
                  ? const Color(0xFFAC5DED).withValues(alpha: 0.15)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.02)),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isPicked ? const Color(0xFFAC5DED) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  item['icon'],
                  size: 12,
                  color: isPicked
                      ? const Color(0xFFAC5DED)
                      : (isDark ? Colors.white38 : Colors.black38),
                ),
                const SizedBox(width: 8),
                Text(
                  item['name'],
                  style: TextStyle(
                    color: isPicked
                        ? const Color(0xFFAC5DED)
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
