import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1023383, size.height * 0.4604517);
    path_0.lineTo(size.width * 0.8328116, size.height * -0.03083110);
    path_0.lineTo(size.width * 0.4949696, size.height * 0.3476984);
    path_0.lineTo(size.width * 0.8967295, size.height * 0.3436716);
    path_0.lineTo(size.width * 0.1023383, size.height * 0.8711971);
    path_0.lineTo(size.width * 0.4584438, size.height * 0.4604517);
    path_0.lineTo(size.width * 0.1023383, size.height * 0.4604517);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4995350, size.height * 0.1753365),
        Offset(size.width * 0.4995350, size.height * 0.8711971), [
      const Color(0xffA117F1).withOpacity(0.05),
      const Color(0xff2954E3).withOpacity(0.05)
    ], [
      0,
      1
    ]);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1023383, size.height * 0.4604517);
    path_1.lineTo(size.width * 0.8328116, size.height * -0.03083110);
    path_1.lineTo(size.width * 0.4949696, size.height * 0.3476984);
    path_1.lineTo(size.width * 0.8967295, size.height * 0.3436716);
    path_1.lineTo(size.width * 0.1023383, size.height * 0.8711971);
    path_1.lineTo(size.width * 0.4584438, size.height * 0.4604517);
    path_1.lineTo(size.width * 0.1023383, size.height * 0.4604517);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.003971945;
    paint1Stroke.color = const Color(0xffF3EBF5).withOpacity(0.4);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xffF3EBF5).withOpacity(0.4);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
