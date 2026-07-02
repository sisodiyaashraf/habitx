import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  // FIXED: Removed the package name prefix to prevent the ClassNotFound double-package error
  static const String _androidWidgetName = 'HabitWidgetProvider';
  static const String _groupId = 'habitx_glass_data';

  /// Initializes the Home Widget service.
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_groupId);
  }

  /// Updates the Home Widget with the optimized daily rotating image.
  static Future<void> updateWidget() async {
    try {
      final now = DateTime.now();

      // Calculate Daily Image Index (1, 2, or 3)
      final imageIndex = (now.day % 3) + 1;
      final String assetPath = 'assets/images/habitx$imageIndex.png';

      debugPrint("HabitX Neural Sync: Rotating daily artwork -> $assetPath");

      final renderWidget = Container(
        width: 100,
        height: 100,
        color: Colors.transparent,
        child: Stack(
          children: [
            ClipPath(
              clipper: WidgetCardClipper(),
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xE61A1A1A), // Dark glass base matching theme
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(assetPath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(100, 100),
              painter: WidgetCardBorderPainter(),
            ),
          ],
        ),
      );

      // FIXED: Dropped logicalSize to 100x100.
      // This is the "Safe Zone" for Android RemoteViews memory limits.
      await HomeWidget.renderFlutterWidget(
        renderWidget,
        key: 'mascot_image',
        logicalSize: const Size(100, 100),
      );

      // FIXED: Using only the class name to prevent the package-doubling crash
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );

      debugPrint("HabitX: Home Widget Sync Complete.");
    } catch (e) {
      debugPrint("HabitX Widget Sync Error: $e");
    }
  }
}

class WidgetCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double r = 16.0; // border radius of corners
    final double notchSize = 36.0; // size of the top-right cutout

    // Start at top-left corner
    path.moveTo(r, 0);
    
    // Line to the start of the notch
    path.lineTo(size.width - notchSize - r, 0);
    
    // Notch curve down
    path.quadraticBezierTo(
      size.width - notchSize,
      0,
      size.width - notchSize,
      r,
    );
    path.lineTo(size.width - notchSize, notchSize - r);
    
    // Notch curve right
    path.quadraticBezierTo(
      size.width - notchSize,
      notchSize,
      size.width - notchSize + r,
      notchSize,
    );
    path.lineTo(size.width - r, notchSize);
    
    // Curve down to right edge
    path.quadraticBezierTo(
      size.width,
      notchSize,
      size.width,
      notchSize + r,
    );
    
    // Down right edge
    path.lineTo(size.width, size.height - r);
    
    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - r,
      size.height,
    );
    
    // Bottom edge
    path.lineTo(r, size.height);
    
    // Bottom-left corner
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - r,
    );
    
    // Left edge
    path.lineTo(0, r);
    
    // Top-left corner
    path.quadraticBezierTo(
      0,
      0,
      r,
      0,
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WidgetCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = WidgetCardClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
