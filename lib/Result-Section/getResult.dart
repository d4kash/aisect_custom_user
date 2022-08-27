import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/appBar.dart';

class GetResult extends StatefulWidget {
  const GetResult({Key? key}) : super(key: key);

  @override
  _GetResultState createState() => _GetResultState();
}

class _GetResultState extends State<GetResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(
        title: "Result ",
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitDoubleBounce(
            size: 120,
            color: Colors.teal,
          ),
          Text("Working On It"),
        ],
      )),
    );
  }
}
