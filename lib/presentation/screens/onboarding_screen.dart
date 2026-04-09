import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../providers/habit_provider.dart';
import '../widgets/shared/glass_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 80,
                color: Color(0xFFAC5DED),
              ),
              const SizedBox(height: 40),
              const Text(
                "Welcome to\nShalcontech Studio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Let's personalize your journey. What should we call you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              _buildNameInput(),
              const SizedBox(height: 30),
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 65,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFFAC5DED).withOpacity(0.5),
          Colors.white.withOpacity(0.2),
        ],
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "Enter your name",
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.text.isNotEmpty) {
          context.read<HabitProvider>().setupUser(_controller.text);
        }
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFAC5DED), Color(0xFF7B61FF)],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "START MY STREAK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
