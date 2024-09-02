import 'package:flutter/material.dart';

class ThermometerWidget extends StatelessWidget {
  final double temperature;

  const ThermometerWidget({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 400),
      painter: ThermometerPainter(temperature),
    );
  }
}

class ThermometerPainter extends CustomPainter {
  final double temperature;

  ThermometerPainter(this.temperature);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double bulbRadius = size.width / 2 - 10;
    final Offset bulbCenter = Offset(size.width / 2, size.height - bulbRadius);
    final double tubeHeight = size.height - 2 * bulbRadius;
    final double tubeWidth = size.width / 2;

    // Draw the tube outline
    final Rect tubeRect = Rect.fromLTWH(
      (size.width - tubeWidth) / 2,
      bulbRadius / 2,
      tubeWidth,
      tubeHeight,
    );
    canvas.drawRect(tubeRect, borderPaint);

    // Calculate the filled height based on the temperature
    final double filledHeight = (temperature / 100) * tubeHeight;
    final Rect filledRect = Rect.fromLTWH(
      (size.width - tubeWidth) / 2,
      tubeHeight - filledHeight + bulbRadius / 2,
      tubeWidth,
      filledHeight,
    );

    // Draw the filled part
    canvas.drawRect(filledRect, redPaint);

    // Draw the remaining white part
    final Rect remainingRect = Rect.fromLTWH(
      (size.width - tubeWidth) / 2,
      bulbRadius / 2,
      tubeWidth,
      tubeHeight - filledHeight,
    );
    canvas.drawRect(remainingRect, whitePaint);

    // Draw the bulb
    canvas.drawCircle(bulbCenter, bulbRadius, redPaint);
    canvas.drawCircle(bulbCenter, bulbRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}