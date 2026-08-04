import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'onboarding_glass_card.dart';

class OnboardingFeatureSlide extends StatelessWidget {
  final Map<String, dynamic> data;
  final AnimationController glowController;
  final AnimationController typingController;

  const OnboardingFeatureSlide({
    super.key,
    required this.data,
    required this.glowController,
    required this.typingController,
  });

  @override
  Widget build(BuildContext context) {
    final color = data['color'] as Color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: OnboardingGlassCard(
            borderColor: color,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedIcon(data['icon'], color),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: typingController,
                    child: Text(
                      data['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: typingController,
                    child: Text(
                      data['subtitle'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(dynamic icon, Color color) {
    return AnimatedBuilder(
      animation: glowController,
      builder: (context, child) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15 * glowController.value),
                blurRadius: 50,
                spreadRadius: 20,
              ),
            ],
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Center(child: FaIcon(icon, size: 60, color: color)),
        );
      },
    );
  }
}
