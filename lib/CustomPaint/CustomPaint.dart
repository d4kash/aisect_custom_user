import 'package:flutter/material.dart';

import '../services/constant.dart';

class ContainerPaint extends StatelessWidget {
  const ContainerPaint({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
     Container(height: Constant.height / 2,width:Constant.width,child: CustomPaint(foregroundPainter: LinePainter(),),));
  }
}



  
  class LinePainter extends CustomPainter {
  
    @override
    void paint(Canvas canvas, Size size) {print(size.height);print(size.width);
    final paint = Paint()..strokeWidth = 30;
    canvas.drawLine(Offset(Constant.width*1/6, Constant.height*1/6,),Offset(Constant.width*1/6, Constant.width*5/6,), paint); 
    }
  
    @override
  
    bool shouldRepaint(CustomPainter oldDelegate) => false;
  
    @override
  
    bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
  }
