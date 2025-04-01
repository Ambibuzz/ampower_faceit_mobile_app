import 'dart:ui';
import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  int totalDays;
  PieChartPainter({
    required this.data,
    required this.totalDays
});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    final List<Color> colors = [
      Color(0xFF189333),
      Color(0xFFC52F2F),
      Color(0xFF006CB5),
      Color(0xFFFF731D),
      Colors.grey
    ];

    double startAngle = -90;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    int index = 0;
    for (var entry in data.entries) {
      final sweepAngle = (entry.value / totalDays) * 360;
      paint.color = colors[index];
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle),
        true,
        paint,
      );
      startAngle += sweepAngle;
      index++;
    }
  }

  double radians(double degrees) => degrees * (3.141592653589793 / 180);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}