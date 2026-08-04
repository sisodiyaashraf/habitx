import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_glass_card.dart';

class IdentityOnboardingStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const IdentityOnboardingStep({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: OnboardingGlassCard(
          borderColor: const Color(0xFFAC5DED),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "NEURAL LINK",
                  style: TextStyle(
                    color: Color(0xFFAC5DED),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Configure Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputLabel("USER_DESIGNATION"),
                _buildTextInput(nameController, "ENTER NAME"),
                const SizedBox(height: 20),
                _buildInputLabel("USER_AGE"),
                _buildTextInput(ageController, "ENTER AGE", isNumber: true),
                const SizedBox(height: 20),
                _buildInputLabel("NOTIFICATION_TONE_GENDER"),
                _buildGenderSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _buildGenderOption("Male")),
        const SizedBox(width: 16),
        Expanded(child: _buildGenderOption("Female")),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = selectedGender == gender;
    Color activeColor = const Color(0xFFAC5DED);
    return GestureDetector(
      onTap: () => onGenderChanged(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isSelected
                ? activeColor
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          gender.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAC5DED),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return OnboardingGlassCard(
      borderColor: const Color(0xFFAC5DED),
      borderRadius: 16,
      blur: 20,
      child: SizedBox(
        height: 56,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }
}
