import 'package:flutter/material.dart';

class DiagonalStrikeThroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF868686)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw diagonal line from bottom-left to top-right
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
