import 'package:flutter/material.dart';

//1
class ProfileCardPainter extends CustomPainter {
  //2
  ProfileCardPainter({required this.color});

  //3
  final Color color;

  //4
  @override
  void paint(Canvas canvas, Size size) {
    CustomPaint();
  }

  //5
  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
