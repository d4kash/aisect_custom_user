import 'package:flutter/material.dart';

import '../services/constant.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  AppBarScreen({Key? key, required this.title})
      : preferredSize = Size.fromHeight(Constant.height / 7),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title,
            style: TextStyle(
              fontSize: Constant.height / 35,
            )),
        toolbarHeight: Constant.height / 7,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.yellow.shade200],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
    );
  }
}
