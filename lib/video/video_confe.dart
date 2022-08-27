import 'package:aisect_custom/widget/appBar.dart';
import 'package:flutter/material.dart';

class VideoConferencing extends StatelessWidget {
  const VideoConferencing({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(title: 'Aisect Meeting Room'),
      body: Center(
        child: Container(
          child: Text('Jisti Meet'),
        ),
      ),
    );
  }
}
