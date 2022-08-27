// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aisect_custom/GetController/theme_controller.dart';
import 'package:aisect_custom/services/FirebaseStorage.dart';
import 'package:aisect_custom/services/constant.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

import '../widget/CourseSelection.dart';
import '../widget/appBar.dart';

class UploadSyllabus extends StatefulWidget {
  const UploadSyllabus({Key? key}) : super(key: key);

  @override
  _UploadSyllabusState createState() => _UploadSyllabusState();
}

class _UploadSyllabusState extends State<UploadSyllabus> {
  // var batch;
  // var Semesterforbd;
  // var coursefordb;
  // var disciplinefordb;
  // var selectedCourse;
  // var selecteddiscipline;
  // List<dynamic> selected = [];
  RxString task = "".obs;

  RxBool isSelectedFile = false.obs;
  UploadTask? upload;
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("Syllabus");

  RxString percentage = "".obs;

  double perce = 0;

  // Timer? _timer;

  RxDouble? progress = 0.00.obs;

  RxBool cancle = false.obs;
  RxBool uploading = false.obs;
  RadioController ctrl = Get.put(RadioController());
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ctrl.selectedbatch.value = "";
    ctrl.selectedSem.value = "";
    ctrl.selected.value = "";
    ctrl.facultySubject.value = "";
    task.value = "";
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: "Upload Syllabus "),
      // resizeToAvoidBottomInset: false,
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
              List<dynamic> jsoncateogery = myDataFromJson["cateogery"];
              return uploadWidget(context, jsonbatch, jsonSemester, jsoncourse,
                  jsondiplomaCourse, jsonug, jsonpg, jsoncateogery, fileName);
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

  Widget uploadWidget(
      BuildContext context,
      List<dynamic> jsonbatch,
      List<dynamic> jsonSemester,
      List<dynamic> jsoncourse,
      List<dynamic> jsondiplomaCourse,
      List<dynamic> jsonug,
      List<dynamic> jsonpg,
      List<dynamic> jsoncateogery,
      String fileName) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
//!DropDown calling
        SizedBox(height: Constant.height / 30),
        Center(
          child: SizedBox(
            width: Constant.width / 1.5,
            child: Text(
              "Selected file: $fileName",
              // style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(height: Constant.height / 28),
        Obx(() => isSelectedFile.isTrue
            ? Center(
                child: Text(ctrl.selectedbatch.string +
                    " of sem " +
                    ctrl.selectedSem.string +
                    " faculty = \n" +
                    ctrl.facultySubject.string +
                    " \n" +
                    "is uploading"),
              )
            : Container()),
        SizedBox(height: Constant.height / 23),
        uploading.isTrue ? buildUploadStatus(upload!) : Container(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 177, 178, 187)),
              child: Obx(() =>
                  Text(isSelectedFile.isTrue ? "select other" : "select file")),
              onPressed: () {
                try {
                  if (ctrl.facultySubject.string == "" ||
                      ctrl.selectedbatch.string == "" ||
                      ctrl.selectedSem.string == "" ||
                      ctrl.selected.string == "") {
                    Constant.showSnackBar(
                        context, "Please Select All Values From DropDown");
                  } else {
                    // cancle.value = true;
                    getPdf();
                    isSelectedFile.value = true;
                  }
                } catch (e) {
                  Constant.showSnackBar(context, "Something w w $e");
                }

                // setState(() {

                // });
              }),
        ),

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(() => cancle.isTrue
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const Text("cancel upload"),
                  onPressed: () async {
                    try {
                      if (upload != null && cancle.isTrue) {
                        await upload!.cancel();
                        cancle.value = false;
                        uploading.value = false;
                        Constant.showSnackBar(context, "upload cancelled");
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      Constant.showSnackBar(context, e.toString());
                    }
                  })
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const Text("upload"),
                  onPressed: () async {
                    try {
                      if (ctrl.facultySubject == "" ||
                          ctrl.selectedbatch == "" ||
                          ctrl.selectedSem == "" ||
                          ctrl.selected == "") {
                        Constant.showSnackBar(
                            context, "Please Select All Values From DropDown");
                      } else {
                        cancle.value = true;
                        await uploadImageToFirebase();
                      }
                    } catch (e) {
                      Constant.showSnackBar(context, "Something w w $e");
                    }
                  })),
        ),

        const SizedBox(height: 20),
      ]),
    );
  }

//!ReBuilds Faculty ui

  // ImagePicker image = ImagePicker();
  File? file;

  getPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withReadStream: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'xlsx', 'xls'],
      );

      if (result != null) {
        file = File(result.files.single.path!);

        setState(() {});
      } else {
        // User canceled the picker
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "s.W. Wrong: $e");
    }
    // uploadImageToFirebase();
    // file = File(img!.path);
  }

//! upload to cloud firestore________________________
  Future uploadImageToFirebase() async {
    try {
      if (file == null) return;

      String fileName = basename(file!.path);
      final destination =
          'Syllabus/${ctrl.selectedbatch.toString()}/${ctrl.selectedSem.toString()}/${ctrl.selected.toString()}/${ctrl.facultySubject.toString()}/$fileName';

      upload = await MyFirebaseStorage.uploadPdf(destination, file!);
      uploading.value = true;
      setState(() {});
      task.value = await (await upload!).ref.getDownloadURL();
      print(task.string);
      print("$upload from ref");
      await addExamData(task.string);
      //clearing data from getx
      cancle.value = false;
      ctrl.selectedbatch.value = "";
      ctrl.selectedSem.value = "";
      ctrl.selected.value = "";
      ctrl.facultySubject.value = "";
      task.value = "";
      isSelectedFile.value = false;
      uploading.value = false;
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: "s.W. Wrong: $e", timeInSecForIosWeb: 900000);
      // Constant.showSnackBar(context, e);
    }
  }

  Future addExamData(String url) async {
    try {
      await _usersCollectionReference
          .doc(ctrl.selectedbatch.string)
          .collection(ctrl.selectedSem.string)
          .doc(ctrl.selected.string)
          .set({"Syllabus": url});
    } catch (e) {
      debugPrint("error: $e");
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget buildUploadStatus(
    UploadTask task,
  ) =>
      StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            progress!.value = snap.bytesTransferred / snap.totalBytes;
            print("progress!.toDouble()");
            print(progress!.toDouble());
            percentage.value = (progress!.value * 100).toStringAsFixed(0);

            print(percentage.string);

            return Obx(
              () => Stack(alignment: AlignmentDirectional.center, children: [
                Text(percentage.string),
                CircularProgressIndicator(
                    color: Colors.deepOrange,
                    strokeWidth: 5,
                    value: progress!.toDouble()),
              ]),
            );
          } else {
            return Container(
              color: Colors.red,
            );
          }
        },
      );
}
