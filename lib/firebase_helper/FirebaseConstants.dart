import 'package:aisect_custom/drawer/page/profile_modal.dart';
import 'package:aisect_custom/model/list_notice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/constant.dart';

var _auth = FirebaseAuth.instance;

var constuid = _auth.currentUser!.uid.toString();
retrieveStudentInfo() async {
  try {
    var collection = FirebaseFirestore.instance.collection('Raw_students_info');
    var docSnapshot = await collection.doc(constuid).get();
    if (docSnapshot.exists || ConnectionState == ConnectionState.done) {
      Map<String, dynamic>? data = docSnapshot.data();
      // var modalData = ProfileModal.fromMap(data!);

      return data;
    }

    // print(Constant.faculty);
  } catch (e) {
    print(e.toString());
  }
}

Widget loadedtextBox(String text, String prefix) {
  return SizedBox(
    height: Constant.height / 30,
    child: Text(
      "$prefix : $text",
      style: TextStyle(
        fontSize: Constant.height / 50,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    ),
  );
}

class FirestoreMethods {
  static retrieveStudentInfo() async {
    try {
      var collection =
          FirebaseFirestore.instance.collection('Raw_students_info');
      var docSnapshot = await collection.doc(constuid).get();
      if (docSnapshot.exists || ConnectionState == ConnectionState.done) {
        Map<String, dynamic>? data = docSnapshot.data();
        var modalData = ProfileModal.fromMap(data!);

        return modalData; //return profileModal
      }

      // print(Constant.faculty);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<dynamic> getNoticeStudents() async {
    var modalData = await retrieveStudentInfo();
    final CollectionReference _usersCollectionReference =
        FirebaseFirestore.instance.collection("Add_Notice");

    var noticeinfo = await _usersCollectionReference
        .doc('students')
        .collection('notice')
        .doc(modalData.batch)
        .collection(modalData.Faculty)
        .doc(modalData.semester)
        .get();

    Map<String, dynamic> data = noticeinfo.data() as Map<String, dynamic>;
    // print(data);

    var noticeList = NoticeList.fromMap(data);
    // print(noticeList.students!);
    return noticeList; //return profileModal
  }
}
