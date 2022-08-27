import 'dart:async';
import 'dart:math';

import 'package:aisect_custom/Home/CompleteProfile.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Home/HomePage copy.dart';
import '../firebase_helper/FirebaseConstants.dart';

class Constant {
  static Color backgroundColor = const Color(0xffe7f0fd);
  static String name = "";
  static String phone = "";
  static double height = Get.size.height;
  static double width = Get.size.width;
  static String roll = "R19CA1IT0001";
  static String batchfromDB = "2019";
  static String semFromDB = "1";
  static String faculty = "1";
  static List<String> revaluationData = [];
  static Timer? _timer;
  static Widget circle() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        color: Colors.purple,
        strokeWidth: 5,
      ),
    );
  }

  static showSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

//Checking------------------------------User on Raw_student_info
  static Future checkUserExist() async {
    try {
      //=====Getting list of all uid from documents raw_student_info
      QueryDocumentSnapshot<Object?> Userid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Raw_students_info")
          .get();
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
          Timer(const Duration(seconds: 3), () => Get.off(() => HomePageNav()));
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
          Timer(const Duration(seconds: 3),
              () => Get.off(() => const CompleteProfile()));
        }
        print(Userid.id);
      }
    } catch (e) {
      print("erroe caught: $e");
      Fluttertoast.showToast(msg: "error: $e");
    }
  }

  static void signInWithPhoneAuthCred() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      // final authCred = await _auth.signInWithCredential(phoneAuthCredential);

      if (_auth.currentUser != null) {
        // LocalData.saveName(name);
        // LocalData.savePhone(phone);
        // var getPhone = LocalData.getPhone();
        // if (phone != getPhone.toString()) {
        //   await LocalData.saveFirstTime(false);
        // } else {}
        checkUserExist();
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);

      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

//-------------------------------------------------------------
//pageRedirection
  static Future onClick(Widget Function() page) async {
    _timer?.cancel();
    await EasyLoading.show(status: 'loading...');
    await Future.delayed(const Duration(milliseconds: 800));
    EasyLoading.dismiss();
    Get.to(() => page());
  }

  Future retrieveData() async {
    try {
      var collection =
          FirebaseFirestore.instance.collection('Raw_students_info');
      var docSnapshot = await collection.doc(constuid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();

        roll = data?["ExamRoll"];
        batchfromDB = data?["batch"];
        semFromDB = data?["semester"];
        // setState(() {});
        // <-- The value you want to retrieve.
        // Call setState if needed.

      }
      print(roll);
      print(batchfromDB);
      print(semFromDB);
    } catch (e) {
      print(e.toString());
    }
  }

  Future data() async {
    final CollectionReference _usersCollectionReference =
        FirebaseFirestore.instance.collection("batchWise");

    String name = "null";
    FutureBuilder<DocumentSnapshot>(
      future: _usersCollectionReference
          .doc(Constant.batchfromDB)
          .collection(Constant.semFromDB)
          .doc(Constant.faculty)
          .collection('StudentRollList')
          .doc(Constant.roll)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const SnackBar(
              content: ScaffoldMessenger(
            child: Text("Something Went wromg"),
          ));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const SnackBar(
              content: ScaffoldMessenger(
            child: Text("Profile Doesn't exist"),
          ));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return const Text("{Model.fromJson(data)}");
          // return Text("Full Name: ${data['full name']}");
        }

        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SpinKitDoubleBounce(color: Colors.blueAccent),
            Text("loading"),
          ],
        ));
      },
    );
  }

//time
//************************************ */
  static String time() {
    String tdata = DateFormat("hh:mm:ss a").format(DateTime.now());
    return tdata;
    // print(tdata);
  }

  static String date() {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return cdate;
  }

  static String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@';
    return List.generate(10, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<String> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    final dateFormat = DateFormat('dd-MM-yyyy');
    final _selecteddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1995),
        lastDate: DateTime(2050));

    if (_selecteddate != null && _selecteddate != currentDate) {
      currentDate = _selecteddate;
      dateFormat.format(_selecteddate);
    }
    return dateFormat.format(_selecteddate!);
  }
}

//time
final height = Get.size.height;
final width = Get.size.width;
