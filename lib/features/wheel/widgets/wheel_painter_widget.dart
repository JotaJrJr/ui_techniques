import 'dart:math';

import 'package:flutter/material.dart';

import '../models/prize_model.dart';

class WheelPainter extends CustomPainter {
  final List<Prize> prizes;

  WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = 360 / prizes.length;

    for (var i = 0; i < prizes.length; i++) {
      final startAngle = i * sweepAngle * (pi / 180);
      final endAngle = (i + 1) * sweepAngle * (pi / 180);

      final paint = Paint()
        ..color = prizes[i].color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        true,
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i].name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textRadius = radius * 0.6;
      final angle = startAngle + (sweepAngle * pi / 180) / 2;
      final textOffset = Offset(
        center.dx + textRadius * cos(angle) - textPainter.width / 2,
        center.dy + textRadius * sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
