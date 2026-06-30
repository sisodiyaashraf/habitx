import 'package:flutter/material.dart';
import 'dart:ui';

class GlassBackground extends StatelessWidget {
  final Widget child;

  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // 1. Vibrant Base Gradient (Light or Dark)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: isDark
                  ? const [
                      Color(0xFF070B19), // Ultra Deep Blue
                      Color(0xFF030D22), // Dark Sapphire
                      Color(0xFF0A1428), // Midnight Blue
                      Color(0xFF000511), // Pure Deep Obsidian
                    ]
                  : const [
                      Color(0xFFF0E5FF), // Soft Lavender
                      Color(0xFFE0EEFF), // Sky Blue
                      Color(0xFFD1E1FF), // Periwinkle
                      Color(0xFFC9D6FF), // Light Blue
                    ],
            ),
          ),
        ),

        // 2. High-Visibility Decorative Orbs
        // Top Left - Glowing Purple/Indigo
        _buildOrb(
          top: -30,
          left: -40,
          size: 320,
          color: isDark
              ? const Color(0xFF7B61FF).withOpacity(0.24)
              : const Color(0xFFAC5DED).withOpacity(0.4),
        ),

        // Bottom Right - Deep Violet/Magenta
        _buildOrb(
          bottom: -50,
          right: -50,
          size: 400,
          color: isDark
              ? const Color(0xFFAC5DED).withOpacity(0.18)
              : const Color(0xFF7B61FF).withOpacity(0.35),
        ),

        // Center Left - Glowing Cyan/Teal for contrast
        _buildOrb(
          top: 350,
          left: -80,
          size: 220,
          color: isDark
              ? const Color(0xFF00F0FF).withOpacity(0.12)
              : Colors.cyanAccent.withOpacity(0.25),
        ),

        // 3. Balanced Blur Layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.3) // Dark Smoked Glass texture
                  : Colors.white.withOpacity(0.05), // Light Milk Glass texture
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
