import 'package:aisect_custom/widget/appBar.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, this.message}) : super(key: key);
  final message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(title: "Message"),
      body: Center(
          child: Text(
        message,
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
