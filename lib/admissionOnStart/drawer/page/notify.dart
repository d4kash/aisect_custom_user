import 'package:aisect_custom/widget/appBar.dart';
import 'package:flutter/material.dart';

class notifyPage extends StatelessWidget {
  const notifyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarScreen(
          title: "Notification",
        ),
        body: Center(
          child: Column(
            children: [Icon(Icons.notification_add), Text("Work in progress")],
          ),
        ),
      ),
    );
  }
}
