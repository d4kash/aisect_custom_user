import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class UID extends ChangeNotifier {
  var uid;

  var _timer;
  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final user = await firebaseUser.uid;

      uid = user.toString();
      notifyListeners();
      print(" initilalized user from profile: ${uid}");
    }
  }
}
