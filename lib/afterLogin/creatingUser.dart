import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import '../services/constant.dart';
import '../widget/appBar.dart';

class CreatingUser extends StatefulWidget {
  const CreatingUser({Key? key}) : super(key: key);

  @override
  State<CreatingUser> createState() => _CreatingUserState();
}

class _CreatingUserState extends State<CreatingUser> {
  @override
  void initState() {
    // TODO: implement initState
    // Constant.signInWithPhoneAuthCred();

    super.initState();
  }

  Future runCode() async {
    return Timer(const Duration(seconds: 3), () {
      Constant.signInWithPhoneAuthCred();
      // updateVisit();
    });
  }

 

  final RxBool _isSucessful = false.obs;
  @override
  Widget build(BuildContext context) {
    runCode();
    return Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(title: ""),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 250.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Agne',
                      color: Color.fromARGB(255, 22, 173, 175),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Getting things ready. . .',
                          speed: const Duration(milliseconds: 155)),
                      // TypewriterAnimatedText('Everyone is ordinary ,',
                      //     speed: const Duration(milliseconds: 120)),
                      // TypewriterAnimatedText('add some extra in ordinary .',
                      //     speed: const Duration(milliseconds: 100)),
                      TypewriterAnimatedText('Here we go . . .'),
                    ],
                    // onTap: () {
                    //   print("Tap Event");
                    // },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
