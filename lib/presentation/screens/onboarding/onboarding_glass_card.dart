import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingGlassCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderRadius;
  final double blur;

  const OnboardingGlassCard({
    super.key,
    required this.child,
    required this.borderColor,
    this.borderRadius = 30,
    this.blur = 25,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
