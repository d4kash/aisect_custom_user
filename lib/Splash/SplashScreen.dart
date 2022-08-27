import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/auth/finger_auth/LoadingScreen.dart';
import 'package:aisect_custom/onboarding/screens/onboard/onboard.dart';
import 'package:aisect_custom/services/LocalData.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../google/widget/sign_up_widget.dart';
import '../services/constant.dart';
import '../widget/platform.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? uid = "";
  @override
  void initState() {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    // navigateUser();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 100, 143).withAlpha(20),
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        return model.isOnline
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                        height: Constant.height / 5,
                        width: Constant.width,
                        child: Lottie.asset('assets/images/education1.json')),
                  ),

                  SizedBox(
                    height: Constant.height / 30,
                  ),
                  DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Agne',
                          color: Color.fromARGB(255, 22, 173, 175),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                      child: AnimatedTextKit(animatedTexts: [
                        TypewriterAnimatedText("AISECT UNIVERSITY",
                            speed: const Duration(milliseconds: 170)),
                      ]))
                  // RichText(
                  //     text: const TextSpan(
                  //         text: "AISECT UNIVERSITY",
                  //         style: TextStyle(color: Colors.blueGrey))),
                ],
              )
            : NoInternet();
      }),
    );
  }

  Future initializeUser() async {
    _user = _auth.currentUser;
    navigateUser();
  }

  Future navigateUser() async {
    try {
      // var onBoardVisited = false;
      var onBoardVisited = await LocalData.checkForFirst();
      print("onBoarding check = $onBoardVisited");
      print("checkUserExist(); in navigate user");
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid.toString();
        final snapShot = await FirebaseFirestore.instance
            .collection('Raw_students_info')
            .doc(uid)
            .get();
        print(snapShot.id);
        if (snapShot.exists) {
          if (!PlatformInfo().isWeb()) {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => BiometricAuth()),
                    (route) => false));
          } else {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePageNav()),
                    (route) => false));
          }
        } else {
          if (onBoardVisited == true) {
            Timer(
                const Duration(seconds: 3),
                () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignUpWidget()),
                    (route) => false));
          } else {
            //navigating too OnBoard
            Timer(
                const Duration(seconds: 3),
                () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Onboard()),
                    (route) => false));
          }
        }
      } else {
        print("checkUserExist(); navigate in else");
        if (onBoardVisited == true) {
          Timer(
              const Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignUpWidget()),
                  (route) => false));
        } else {
          //navigating too OnBoard
          Timer(
              const Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Onboard()),
                  (route) => false));
        } //this leads to phoneauth for students
      }
    } catch (e) {
      print(e);
    }
  }
  // Future checkUserExist() async {
  //   final snapShot = await FirebaseFirestore.instance
  //       .collection('Raw_students_info')
  //       .doc(uid)
  //       .get();
  //   print("checkUserExist()");
  //   if (snapShot.exists) {
  //     // Document already exists
  //     Fluttertoast.showToast(msg: "alredy exist");
  //     print("User $uid already exist and not necessary to be created");
  //     Timer(
  //         Duration(milliseconds: 3),
  //         () => Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => BiometricAuth()),
  //             (route) => false));
  //     // Timer(
  //     //     Duration(milliseconds: 300),
  //     //     () => Navigator.pushReplacement(context,
  //     //         MaterialPageRoute(builder: (context) => CompleteProfile())));
  //   } else {
  //     print("checkUserExist() in else");
  //     Timer(
  //         Duration(milliseconds: 300),
  //         () => Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => HomePageForauth())));
  //   }
  // }
}
