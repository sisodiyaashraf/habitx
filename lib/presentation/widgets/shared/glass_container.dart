import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    // Need to clip the filter or it blurs the whole screen
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(24),
            // Light neumorphic border and shadow
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(4, 4),
              ),
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                color: Colors.white.withOpacity(0.05),
                offset: const Offset(-4, -4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
