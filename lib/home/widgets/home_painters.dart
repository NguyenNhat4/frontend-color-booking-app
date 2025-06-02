import 'package:flutter/material.dart';
import '../../core/theme/paint_app_colors.dart';

/// Custom painter for animated home background
class HomeBackgroundPainter extends CustomPainter {
  final double animationValue;
  final String userType;

  HomeBackgroundPainter(this.animationValue, this.userType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final userColor = PaintAppColors.getUserTypeColor(userType);

    // Animated circles
    paint.color = userColor.withValues(alpha: 0.1 * animationValue);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      50 + (animationValue * 20),
      paint,
    );

    paint.color = userColor.withValues(alpha: 0.05 * (1 - animationValue));
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      30 + (animationValue * 15),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for feature card backgrounds
class FeatureCardBackgroundPainter extends CustomPainter {
  final Color color;

  FeatureCardBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Subtle pattern
    paint.color = color.withValues(alpha: 0.1);

    final path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
