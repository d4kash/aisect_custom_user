import 'dart:async';

import 'package:aisect_custom/widget/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Check extends StatelessWidget {
  const Check({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<dynamic> abc = const ["a", "b", "c", "d", "e"];
    return Scaffold(
      body: Center(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDropdown(
                text: "hello",
                cateogery: abc,
                onItemSelect: (value) {
                  print("object12 ${abc.elementAt(value)}");
                },
              ),
              const SizedBox(
                height: 50,
              ),
              CustomDropdown(
                text: "value",
                cateogery: abc,
                onItemSelect: (value) {
                  print("object12 ${abc.elementAt(value)}");
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}

//Contrller for customDropDown
class DropDown1 extends GetxController {
  RxString get_text = "".obs;
  RxInt index = 30.obs;
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

const int TIME_REMINDING_SECONDS = 480;

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _start = TIME_REMINDING_SECONDS;

  @override
  Widget build(BuildContext context) {
    return Text(
        '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
        style: TextStyle(
            color: _start > 10 ? Colors.amber : Colors.red, fontSize: 20));
  }

  @override
  initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
}
