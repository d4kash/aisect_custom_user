import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/admissionOnStart/AdmissionOnStart.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';

import 'package:aisect_custom/widget/customDialog.dart';
import 'package:aisect_custom/Home/CompleteProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:aisect_custom/services/LocalData.dart';
//!Email SignIN

Future<User?> signInUsingEmailPassword({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      AdvanceDialog(
        title: "Error",
        s: e.code,
      );
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
      AdvanceDialog(
        title: "Error",
        s: e.code,
      );
    }
  }

  return user;
}

//! Phone auth for admission section
FirebaseAuth _auth = FirebaseAuth.instance;
void signInWithPhoneAuthCredForAdmission(
    AuthCredential phoneAuthCredential) async {
  try {
    final authCred = await _auth.signInWithCredential(phoneAuthCredential);

    if (authCred.user != null) {
      // localData.saveName(nameController.text);
      // localData.savePhone(phoneController.text);
      checkUserExistForAdmisison();
      // Timer(
      //     Duration(milliseconds: 300),
      //     () => Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => zoomDrawerHome())));
    }
  } on FirebaseAuthException catch (e) {
    print(e.message);
    // showToast(e.message.toString());
    Fluttertoast.showToast(msg: e.message.toString());
  }
}

Future checkUserExistForAdmisison() async {
  final snapShot = await FirebaseFirestore.instance
      .collection('students')
      .doc(constuid)
      .get();

  if (snapShot.exists) {
    // Document already exists
    Fluttertoast.showToast(msg: "alredy exist");
    print("User $constuid already exist and not necessary to be created");
    Timer(const Duration(milliseconds: 300),
        () => Get.offAll(() => const ApplicationOnStart())
        //Navigator.pushReplacement(context,
        // MaterialPageRoute(builder: (context) => ApplicationOnStart())
        );
  } else {
    // showDialogFirstTime();
    Timer(const Duration(milliseconds: 300),
        () => Get.off(() => const ApplicationOnStart()));
  }
}
//!SignOut

void SignOutME() async {
  await _auth.signOut();
}
//! For Registered Students

Future checkUserExist() async {
  //=====Getting list of all uid from documents raw_student_info
  QueryDocumentSnapshot<Object?> Userid;
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Raw_students_info").get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    Userid = querySnapshot.docs[i];
    if (Userid.id == constuid) {
      // Document already exists
      // if (Userid.id == constuid) {
      Fluttertoast.showToast(msg: "alredy exist in students ");
      print("User $constuid already exist and not necessary to be created");
      // Timer(const Duration(milliseconds: 300),
      //     () => Get.off(() => CompleteProfile()));
      print("found in if condn");
      Timer(const Duration(milliseconds: 300),
          () => Get.off(() => HomePageNav()));
      // / Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => CompleteProfile()),
      //     (route) => false,

      break;

      // break;
    } else {
      print("i'm in else condition ");
      print("not found in else condn");
      // showDialogFirstTime();
      // Timer(const Duration(milliseconds: 30),
      //     () => Get.off(() => const HomePage()));
      Timer(const Duration(milliseconds: 300),
          () => Get.off(() => const CompleteProfile()));
      // Timer(const Duration(milliseconds: 30),
      //     () => Get.off(() => const HomePage()));
    }
    print(Userid.id);
  }
}

void signInWithPhoneAuthCred(
    AuthCredential phoneAuthCredential, String name, String phone) async {
  try {
    final authCred = await _auth.signInWithCredential(phoneAuthCredential);

    if (authCred.user != null) {
      LocalData.saveName(name);
      LocalData.savePhone(phone);
      var getPhone = LocalData.getPhone();
      if (phone != getPhone.toString()) {
        await LocalData.saveFirstTime(false);
      } else {}
      checkUserExist();
      // Timer(
      //     Duration(milliseconds: 300),
      //     () => Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => zoomDrawerHome())));
    }
  } on FirebaseAuthException catch (e) {
    print(e.message);
    // showToast(e.message.toString());
    // setState(() {
    //   _isLoadingForverify = false;
    // });
    Fluttertoast.showToast(msg: e.message.toString());
  }
}
