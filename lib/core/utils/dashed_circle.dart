import 'dart:math';

import 'package:flutter/material.dart';

class DashedCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;

  const DashedCircle({
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = 3,
    this.dash = 6,
    this.gap = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dash,
        gapLength: gap,
      ),
      size: Size(size, size),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final angle = 2 * pi;
    final circumference = angle * radius;

    final dashCount = circumference ~/ (dashLength + gapLength);
    final dashAngle = angle / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashAngle * (dashLength / (dashLength + gapLength)),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
