// import 'dart:convert';

import 'dart:convert';

import 'package:aisect_custom/Exam_panel/down.dart';
import 'package:aisect_custom/Exam_panel/timetable_widget/selectDropdownwidget.dart';
import 'package:aisect_custom/GetController/theme_controller.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../widget/CourseSelection.dart';

class StudyNotes extends StatefulWidget {
  const StudyNotes({Key? key}) : super(key: key);

  @override
  _StudyNotesState createState() => _StudyNotesState();
}

class _StudyNotesState extends State<StudyNotes> {
  RadioController ctrl = Get.put(RadioController());
  bool dataAvailable = false;
  List<dynamic> selected = [];

  @override
  Widget build(BuildContext context) {
    return SameDropDown(
        onPressed: () async {
          if (ctrl.facultySubject.string != "") {
            await getExamData();
            print("i was beaten");
            download d = download();
            try {
              if (data["Notes"] != null) {
                await d.downloadFile("${data["Notes"]}");

                Constant.showSnackBar(
                    context, "Notes PDF is saved on Aisect Folder");
              }
            } catch (e) {
              debugPrint(" error: $e");
              Constant.showSnackBar(context, "select to download");
              print("data is null");
              print("can't proceed further");
            }
          } else {
            Constant.showSnackBar(context, "Please fill all required details");
          }
        },
        FormText: 'Study Notes',
        buttonText: 'Download');
  }

  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("Notes");
  var data;
  Future getExamData() async {
    try {
      _usersCollectionReference
          .doc(ctrl.selectedbatch.string)
          .collection(ctrl.selectedSem.string)
          .doc(ctrl.selected.string)
          .snapshots()
          .listen((snapshot) {
        try {
          print(snapshot.data());
          if (snapshot.data() != null) {
            // print("${data["timetable"]}");
            setState(() {
              data = snapshot.data();
              print(snapshot.data());
            });
          } else {
            print("object is null");
          }
          // print(dataAvailable);
        } catch (e) {
          print("error: $e");
          // Fluttertoast.showToast(msg: e.toString());
        }
      });
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }
}
// // import 'dart:convert';

// import 'dart:convert';

// import 'package:aisect_custom/Exam_panel/down.dart';
// import 'package:aisect_custom/GetController/theme_controller.dart';
// import 'package:aisect_custom/services/constant.dart';
// import 'package:aisect_custom/widget/appBar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// import '../widget/CourseSelection.dart';

// class StudyNotes extends StatefulWidget {
//   const StudyNotes({Key? key}) : super(key: key);

//   @override
//   _StudyNotesState createState() => _StudyNotesState();
// }

// class _StudyNotesState extends State<StudyNotes> {
//   RadioController ctrl = Get.put(RadioController());
//   bool dataAvailable = false;
//   List<dynamic> selected = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffe7f0fd),
//       appBar: AppBarScreen(
//         title: "Study Notes",
//       ),
//       // appBar: AppBar(title: Text("Apply For Admission"),
//       // ),
//       // resizeToAvoidBottomInset: false,

//       body: FutureBuilder(
//         future: DefaultAssetBundle.of(context)
//             .loadString("assets/files/courses.json"),
//         builder: (context, AsyncSnapshot snapshot) {
//           try {
//             var myDataFromJson = json.decode(snapshot.data.toString());

//             if (snapshot.connectionState == ConnectionState.done) {
//               List<dynamic> jsondiplomaCourse = myDataFromJson["Diploma"];
//               List<dynamic> jsonSemester = myDataFromJson["semester"];

//               List<dynamic> jsonug = myDataFromJson["UG"];
//               // print(jsonug);
//               List<dynamic> jsonpg = myDataFromJson["PG"];
//               List<dynamic> jsonbatch = myDataFromJson["batch"];
//               // print(jsonpg);
//               List<dynamic> jsoncourse = myDataFromJson["course"];
//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(
//                     parent: AlwaysScrollableScrollPhysics()),
//                 child: Column(children: <Widget>[
//                   //! For Course Selection
//                   CourseDropDown(
//                     jsonbatch: jsonbatch,
//                     jsoncourse: jsoncourse,
//                     jsondiplomaCourse: jsondiplomaCourse,
//                     jsonpg: jsonpg,
//                     jsonSemester: jsonSemester,
//                     jsonug: jsonug,
//                   ),

//                   SizedBox(
//                     height: Constant.height / 50,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (ctrl.facultySubject.string != "") {
//                         await getExamData();
//                         print("i was beaten");
//                         download d = download();
//                         try {
//                           if (data["Notes"] != null) {
//                             await d.downloadFile("${data["Notes"]}");

//                             Constant.showSnackBar(
//                                 context, "Notes PDF is saved on Aisect Folder");
//                           }
//                         } catch (e) {
//                           debugPrint(" error: $e");
//                           Constant.showSnackBar(context, "select to download");
//                           print("data is null");
//                           print("can't proceed further");
//                         }
//                       } else {
//                         Constant.showSnackBar(
//                             context, "Please fill all required details");
//                       }
//                     },
//                     child: const Text("download"),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                 ]),
//               );
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text("Loading"),
//                   CircularProgressIndicator(),
//                 ],
//               );
//             }
//           } catch (e) {
//             return Constant.showSnackBar(context, "Something Went Wrong: $e");
//           }
//         },
//       ),
//     );
//   }

//   final CollectionReference _usersCollectionReference =
//       FirebaseFirestore.instance.collection("Notes");
//   var data;
//   Future getExamData() async {
//     try {
//       _usersCollectionReference
//           .doc(ctrl.selectedbatch.string)
//           .collection(ctrl.selectedSem.string)
//           .doc(ctrl.selected.string)
//           .snapshots()
//           .listen((snapshot) {
//         try {
//           print(snapshot.data());
//           if (snapshot.data() != null) {
//             // print("${data["timetable"]}");
//             setState(() {
//               data = snapshot.data();
//               print(snapshot.data());
//             });
//           } else {
//             print("object is null");
//           }
//           // print(dataAvailable);
//         } catch (e) {
//           print("error: $e");
//           // Fluttertoast.showToast(msg: e.toString());
//         }
//       });
//     } catch (e) {
//       return Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }
