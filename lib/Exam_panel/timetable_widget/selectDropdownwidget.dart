// import 'dart:convert';

import 'dart:convert';

import 'package:aisect_custom/Exam_panel/down.dart';
import 'package:aisect_custom/GetController/theme_controller.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/CourseSelection.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/custom_button.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SameDropDown extends StatefulWidget {
  SameDropDown(
      {Key? key,
      required this.onPressed,
      required this.FormText,
      required this.buttonText})
      : super(key: key);
  final String FormText;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  _SameDropDowneState createState() => _SameDropDowneState();
}

class _SameDropDowneState extends State<SameDropDown> {
  RadioController ctrl = Get.put(RadioController());
  bool dataAvailable = false;
  List<dynamic> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: widget.FormText),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/files/courses.json"),
        builder: (context, AsyncSnapshot snapshot) {
          try {
            var myDataFromJson = json.decode(snapshot.data.toString());

            if (snapshot.connectionState == ConnectionState.done) {
              List<dynamic> jsondiplomaCourse = myDataFromJson["Diploma"];
              List<dynamic> jsonSemester = myDataFromJson["semester"];

              List<dynamic> jsonug = myDataFromJson["UG"];
              // print(jsonug);
              List<dynamic> jsonpg = myDataFromJson["PG"];
              List<dynamic> jsonbatch = myDataFromJson["batch"];
              // print(jsonpg);
              List<dynamic> jsoncourse = myDataFromJson["course"];
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(children: <Widget>[
                  //! For Course Selection
                  CourseDropDown(
                    jsonbatch: jsonbatch,
                    jsoncourse: jsoncourse,
                    jsondiplomaCourse: jsondiplomaCourse,
                    jsonpg: jsonpg,
                    jsonSemester: jsonSemester,
                    jsonug: jsonug,
                  ),
                  //?ForSemester

                  SizedBox(
                    height: Constant.height / 50,
                  ),
                  CustomButtonNew(
                      text: widget.buttonText, onPressed: widget.onPressed),
                  const SizedBox(
                    height: 30,
                  ),
                ]),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Loading"),
                  CircularProgressIndicator(),
                ],
              );
            }
          } catch (e) {
            return Constant.showSnackBar(context, "Something Went Wrong: $e");
          }
        },
      ),
    );
  }

  // final CollectionReference _usersCollectionReference =
  //     FirebaseFirestore.instance.collection("ExamSchedule");
  // var data;
  // Future getExamData() async {
  //   try {
  //     _usersCollectionReference
  //         .doc(ctrl.selectedbatch.string)
  //         .collection(ctrl.selectedSem.string)
  //         .doc(ctrl.selected.string)
  //         .snapshots()
  //         .listen((snapshot) {
  //       try {
  //         print(snapshot.data());
  //         if (snapshot.data() != null) {
  //           // print("${data["timetable"]}");
  //           setState(() {
  //             data = snapshot.data();
  //             print(snapshot.data());
  //           });
  //         } else {
  //           print("object is null");
  //         }
  //         // print(dataAvailable);
  //       } catch (e) {
  //         print("error: $e");
  //         // Fluttertoast.showToast(msg: e.toString());
  //       }
  //     });
  //   } catch (e) {
  //     return Fluttertoast.showToast(msg: e.toString());
  //   }
  // }
}
