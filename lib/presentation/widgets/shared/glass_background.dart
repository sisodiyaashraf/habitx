import 'package:flutter/material.dart';
import 'dart:ui';

class GlassBackground extends StatelessWidget {
  final Widget child;

  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Vibrant Base Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFFF0E5FF), // Soft Lavender
                Color(0xFFE0EEFF), // Sky Blue
                Color(0xFFD1E1FF), // Periwinkle
                Color(0xFFC9D6FF), // Light Blue
              ],
            ),
          ),
        ),

        // 2. High-Visibility Decorative Orbs
        // Top Left - Strong Brand Purple
        _buildOrb(
          top: -30,
          left: -40,
          size: 320,
          color: const Color(
            0xFFAC5DED,
          ).withOpacity(0.4), // Increased opacity for visibility
        ),

        // Bottom Right - Deep Lavender Blue
        _buildOrb(
          bottom: -50,
          right: -50,
          size: 400,
          color: const Color(0xFF7B61FF).withOpacity(0.35),
        ),

        // Center Left - Accent Cyan/Teal for contrast
        _buildOrb(
          top: 350,
          left: -80,
          size: 220,
          color: Colors.cyanAccent.withOpacity(0.25),
        ),

        // 3. Balanced Blur Layer
        // Lowering sigma slightly (from 60 to 45) makes the color shapes more "visible"
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
            child: Container(
              color: Colors.white.withOpacity(
                0.05,
              ), // Adds a slight "milk" texture
            ),
          ),
        ),

        // 4. The Screen Content
        child,
      ],
    );
  }

  Widget _buildOrb({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
