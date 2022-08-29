import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/auth/controllers/authentications.dart';
import 'package:aisect_custom/google/lib/services/firebase_auth_methods.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../google/widget/sign_up_widget.dart';
import '../../../widget/appBar.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  @override
  void initState() {
    // TODO: implement initState
    // initializeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final signout = LoginA();
    return Scaffold(
      appBar: AppBarScreen(title: "Logout"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sure! see you soon'),
            SizedBox(height: height / 20),
            const Icon(Icons.logout),
            CustomButtonNew(
                onPressed: () async {
                  final User? currentUser = await _auth.currentUser;
                  try {
                    if (currentUser!.providerData[0].providerId ==
                        'google.com') {
                      print("in if condn");
                      await GoogleSignIn().signOut().then((value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SignUpWidget()),
                              (route) => false));
                      // await googleSignIn.disconnect();
                    } else {
                      print("in else condn");
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SignUpWidget()),
                              (route) => false));
                    }
                  } catch (e) {
                    print("$e");
                  }

                  print("logged Out");
                },
                text: "Logout")
          ],
        ),
      ),
    );
  }

  Future initializeUser() async {
    context.read<FirebaseAuthMethods>().signOut(context);
  }

  navigateUser() {
    context.read<FirebaseAuthMethods>().signOut(context);
    if (_auth.currentUser != null) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageNav()),
              (route) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignUpWidget()),
              (route) => false));
    }
  }
}
