import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ProgressItemTile extends StatelessWidget {
  final String title;
  final String progress;
  final IconData icon; // Correctly implemented

  const ProgressItemTile({
    super.key,
    required this.title,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 85, // Slightly taller for better vertical centering
        borderRadius: 22,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3), // More "milky" for text contrast
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFAC5DED).withOpacity(0.4),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // High-Contrast Icon Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFAC5DED).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFAC5DED).withOpacity(0.2),
                  ),
                ),
                child: Icon(icon, color: const Color(0xFFAC5DED), size: 24),
              ),
              const SizedBox(width: 16),

              // Text Content using Onyx Hierarchy
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black, // Onyx Visibility
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      progress,
                      style: const TextStyle(
                        color: Colors.black54, // Clear subtext contrast
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Right-aligned status arrow
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black26,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
