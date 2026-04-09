import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/models/habit.dart';
import '../../../providers/habit_provider.dart';

class AddHabitForm extends StatefulWidget {
  const AddHabitForm({super.key});

  @override
  State<AddHabitForm> createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<AddHabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _customTimeController = TextEditingController();

  HabitDifficulty _selectedDifficulty = HabitDifficulty.easy;
  int _selectedMinutes = 10;
  bool _isCustomTimer = false;
  bool _isWeeklySchedule = false;
  bool _isReminderEnabled = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final Map<String, List<Map<String, dynamic>>> _habitLibrary = {
    "Popular": [
      {"name": "Coding", "icon": FontAwesomeIcons.code},
      {"name": "Reading", "icon": FontAwesomeIcons.bookOpen},
      {"name": "Gym", "icon": FontAwesomeIcons.dumbbell},
      {"name": "Meditation", "icon": FontAwesomeIcons.brain},
    ],
    "Health": [
      {"name": "Drink Water", "icon": FontAwesomeIcons.droplet},
      {"name": "Morning Walk", "icon": FontAwesomeIcons.personWalking},
      {"name": "Healthy Meal", "icon": FontAwesomeIcons.appleWhole},
      {"name": "Skin Care", "icon": FontAwesomeIcons.faceGrinSquint},
      {"name": "Bath/Shower", "icon": FontAwesomeIcons.bath},
    ],
    "Productivity": [
      {"name": "Deep Work", "icon": FontAwesomeIcons.laptopCode},
      {"name": "Journaling", "icon": FontAwesomeIcons.penNib},
      {"name": "Planning", "icon": FontAwesomeIcons.calendarCheck},
      {"name": "Learning", "icon": FontAwesomeIcons.graduationCap},
    ],
    "Self-Care": [
      {"name": "Stretching", "icon": FontAwesomeIcons.childReaching},
      {"name": "Nap", "icon": FontAwesomeIcons.bed},
      {"name": "Music", "icon": FontAwesomeIcons.music},
      {"name": "Prayer", "icon": FontAwesomeIcons.prayingHands},
    ],
    "Skills": [
      {"name": "Design", "icon": FontAwesomeIcons.palette},
      {"name": "Writing", "icon": FontAwesomeIcons.pen},
      {"name": "Language", "icon": FontAwesomeIcons.language},
      {"name": "Gaming", "icon": FontAwesomeIcons.gamepad},
    ],
  };

  String _selectedCategory = "Popular";
  dynamic _currentIcon = FontAwesomeIcons.fontAwesome;

  @override
  void initState() {
    super.initState();
    _selectedDate = context.read<HabitProvider>().selectedDate;
  }

  // --- Logic remain unchanged ---
  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _applyPickerTheme(context, child!, isDark),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => _applyPickerTheme(context, child!, isDark),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Widget _applyPickerTheme(BuildContext context, Widget child, bool isDark) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: Color(0xFFAC5DED),
                onPrimary: Colors.white,
                surface: Color(0xFF1A1A1A),
              )
            : const ColorScheme.light(
                primary: Color(0xFFAC5DED),
                onPrimary: Colors.white,
                surface: Colors.white,
              ),
      ),
      child: child,
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final habitProvider = context.read<HabitProvider>();
      int finalMinutes =
          (_isCustomTimer && _customTimeController.text.isNotEmpty)
          ? int.tryParse(_customTimeController.text) ?? _selectedMinutes
          : _selectedMinutes;

      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        difficulty: _selectedDifficulty,
        timerDuration: finalMinutes,
        createdAt: scheduledDateTime,
        reminderTime: _isReminderEnabled ? scheduledDateTime : null,
        isCompleted: false,
        streak: 0,
        lastCompleted: DateTime.now(),
      );

      habitProvider.addHabit(newHabit);
      Navigator.pop(context);
    }
  }

  void _selectPreset(String name, dynamic icon) {
    setState(() {
      _nameController.text = name;
      _currentIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return GlassmorphicContainer(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      borderRadius: 40,
      blur: 35,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.25),
          isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [const Color(0xFFAC5DED).withOpacity(0.6), Colors.transparent],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(textColor),
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("MISSION LIBRARY", isDark),
                      _buildCategorySelector(isDark),
                      const SizedBox(height: 12),
                      _buildPresetGrid(isDark, textColor),
                      const SizedBox(height: 35),
                      _buildLabel("CORE CONFIGURATION", isDark),
                      _buildGlassTextField(
                        _nameController,
                        "Mission title...",
                        _currentIcon,
                        isDark,
                        textColor,
                      ),
                      const SizedBox(height: 20),
                      _buildDateTimeRow(context, isDark, textColor),
                      const SizedBox(height: 20),
                      _buildReminderToggle(isDark, textColor),
                      const SizedBox(height: 30),
                      _buildLabel("INTENSITY & TIME", isDark),
                      _buildGlassDropdown(isDark, textColor),
                      const SizedBox(height: 15),
                      _buildTimerOptions(isDark, textColor),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(
          FontAwesomeIcons.rocket,
          color: Color(0xFFAC5DED),
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          "ACTIVATE MISSION",
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _habitLibrary.keys.map((cat) {
          bool isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFAC5DED)
                    : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03)),
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFAC5DED).withOpacity(0.3),
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
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPresetGrid(bool isDark, Color textColor) {
    final presets = _habitLibrary[_selectedCategory]!;
    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 150,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: presets.length,
        itemBuilder: (context, index) {
          final item = presets[index];
          bool isPicked = _nameController.text == item['name'];
          return GestureDetector(
            onTap: () => _selectPreset(item['name'], item['icon']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isPicked
                    ? const Color(0xFFAC5DED).withOpacity(0.15)
                    : (isDark
                          ? Colors.white.withOpacity(0.03)
                          : Colors.black.withOpacity(0.02)),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isPicked
                      ? const Color(0xFFAC5DED)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    item['icon'],
                    size: 14,
                    color: isPicked
                        ? const Color(0xFFAC5DED)
                        : (isDark ? Colors.white38 : Colors.black38),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item['name'],
                    style: TextStyle(
                      color: isPicked
                          ? const Color(0xFFAC5DED)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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

  Widget _buildLabel(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
    child: Text(
      text,
      style: TextStyle(
        color: const Color(0xFFAC5DED).withOpacity(0.8),
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    ),
  );

  Widget _buildGlassTextField(
    TextEditingController controller,
    String hint,
    dynamic icon,
    bool isDark,
    Color textColor,
  ) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor.withOpacity(0.2)),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14.0),
          child: FaIcon(icon, color: const Color(0xFFAC5DED), size: 18),
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFAC5DED), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDateTimeRow(BuildContext context, bool isDark, Color textColor) {
    return Row(
      children: [
        Expanded(
          child: _buildPickerTrigger(
            onTap: () => _selectDate(context),
            text: DateFormat('MMM d').format(_selectedDate),
            icon: FontAwesomeIcons.calendarDay,
            isDark: isDark,
            textColor: textColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPickerTrigger(
            onTap: () => _selectTime(context),
            text: _selectedTime.format(context),
            icon: FontAwesomeIcons.clock,
            isDark: isDark,
            textColor: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPickerTrigger({
    required VoidCallback onTap,
    required String text,
    required dynamic icon,
    required bool isDark,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: const Color(0xFFAC5DED), size: 16),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderToggle(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FaIcon(
                _isReminderEnabled
                    ? FontAwesomeIcons.solidBell
                    : FontAwesomeIcons.solidBellSlash,
                color: const Color(0xFFAC5DED),
                size: 18,
              ),
              const SizedBox(width: 15),
              Text(
                "SET REMINDER",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: _isReminderEnabled,
            activeColor: const Color(0xFFAC5DED),
            onChanged: (val) => setState(() => _isReminderEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassDropdown(bool isDark, Color textColor) {
    return DropdownButtonFormField<HabitDifficulty>(
      value: _selectedDifficulty,
      dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      icon: const Icon(Icons.expand_more_rounded, color: Color(0xFFAC5DED)),
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: HabitDifficulty.values
          .map(
            (d) =>
                DropdownMenuItem(value: d, child: Text(d.name.toUpperCase())),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedDifficulty = val!),
    );
  }

  Widget _buildTimerOptions(bool isDark, Color textColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...[10, 20, 30].map(
              (mins) => _choiceChip(
                "$mins m",
                !_isCustomTimer && _selectedMinutes == mins,
                () {
                  setState(() {
                    _isCustomTimer = false;
                    _selectedMinutes = mins;
                    _customTimeController.clear();
                  });
                },
                isDark,
                textColor, // Pass textColor
              ),
            ),
            _choiceChip(
              "CUSTOM",
              _isCustomTimer,
              () => setState(() => _isCustomTimer = true),
              isDark,
              textColor, // Pass textColor
            ),
          ],
        ),
        // --- NEW: Custom Input Field appears when _isCustomTimer is true ---
        if (_isCustomTimer)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _buildGlassTextField(
              _customTimeController,
              "Minutes (e.g. 45)",
              FontAwesomeIcons.stopwatch,
              isDark,
              textColor,
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
    Color textColor, // Added this parameter
  ) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFAC5DED)
              : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFAC5DED).withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAC5DED).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: _saveHabit,
        child: const Text(
          'ACTIVATE MISSION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customTimeController.dispose();
    super.dispose();
  }
}
