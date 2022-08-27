import 'dart:async';

import 'package:aisect_custom/Authenticate/LoginScree.dart';
import 'package:aisect_custom/Home/CompleteProfile.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:aisect_custom/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key, this.selectedDetails}) : super(key: key);
  final selectedDetails;
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        return model.isOnline
            ? Container(
                color: Colors.indigo.withAlpha(20),
                child: Center(child: Text("")),
              )
            : NoInternet();
      }),
    );
  }

  Future initializeUser() async {
    _user = await _auth.currentUser;
    if (widget.selectedDetails == 'admission') {
      await checkUserExistAdmission(context);
    } else {
      await navigateUser();
    }
  }

  Future navigateUser() async {
    print("checkUserExist(); in navigate user 1");
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid.toString();
      final snapShot = await FirebaseFirestore.instance
          .collection('Raw_students_info')
          .doc(uid)
          .get();
      print(snapShot.id);
      if (snapShot.exists) {
        Timer(
            Duration(milliseconds: 30),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomePageNav()), //BiometricAuth
                (route) => false));
      } else {
        print(" called completeProfile; navigate in else 1 ");
        Timer(
            Duration(milliseconds: 30),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        CompleteProfile()), //AplicationONStart
                (route) => false));
      }
    } else {
      print("checkUserExist(); navigate in else");
      Timer(
          Duration(milliseconds: 40),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final CollectionReference _userCollectionRef =
  //     _firestore.collection("New_Admission_Request");
//! creating user for Admission
  // static Future createUserAdmission() async {
  //   try {
  //     await _userCollectionRef.doc(constuid).set({
  //       'admission-section': true,
  //     });
  //   } catch (e) {
  //     return Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  static Future checkUserExistAdmission(BuildContext context) async {
    try {
      //=====Getting list of all uid from documents raw_student_info
      // QueryDocumentSnapshot<Object?> Userid;

      if (_auth.currentUser != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection("New_Admission_Request")
            .doc(constuid)
            .get();
        print(querySnapshot.id);
        if (querySnapshot.exists) {
          Timer(
              Duration(milliseconds: 30),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => AdmissionHome()), //BiometricAuth
                  (route) => false));
        } else {
          print(" called completeProfile; navigate in else 1 ");
          Timer(
              Duration(milliseconds: 30),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()), //AplicationONStart
                  (route) => false));
        }
      } else {
        print("checkUserExist(); navigate in else");
        Timer(
            Duration(milliseconds: 40),
            () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen())));
      }
//       for (int i = 0; i < querySnapshot.docs.length; i++) {
//         Userid = querySnapshot.docs[i];
//         if (Userid.id == constuid) {
//           // Document already exists
//           // if (Userid.id == constuid) {
//           Fluttertoast.showToast(msg: "Success");
//           print("User $constuid already exist and not necessary to be created");

//           print("found in if condn");
//           Timer(const Duration(seconds: 3),
//               () => Navigator.pushNamed(context, AppRoutes.admissionHome));
// // isSearching = false;
//           break;
//         } else {
//           print("i'm in else condition ");
//           print("not found in else condn");
//           createUserAdmission();
//           Timer(const Duration(seconds: 3),
//               () => Navigator.pushNamed(context, AppRoutes.admissionHome));
//           // isSearching = false;
//         }
//         print(Userid.id);
//       }
    } catch (e) {
      print("erroe caught: $e");
      Fluttertoast.showToast(msg: "error: $e");
    }
  }
}
