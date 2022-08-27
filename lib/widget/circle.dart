import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  const Circle({Key? key}) : super(key: key);

  @override
  CirclePageState createState() => CirclePageState();
}

class CirclePageState extends State<Circle> with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: animationController
            .drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),
      ),
    );
  }
}
