import 'dart:convert';

import 'package:aisect_custom/GetController/theme_controller.dart';
import 'package:aisect_custom/model/noticeModal.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/CourseSelection.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class NoticeAdminHome extends StatefulWidget {
  @override
  _NoticeAdminHomeState createState() => _NoticeAdminHomeState();
}

class _NoticeAdminHomeState extends State<NoticeAdminHome> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('Add_Notice').snapshots();
  final CollectionReference addNoticeManagement =
      FirebaseFirestore.instance.collection("Add_Notice");
  final CollectionReference addNotice =
      FirebaseFirestore.instance.collection("Add_Notice");
  final formKey = GlobalKey<FormState>();
  String? departSelected;
  String? managSelected;
  RxString? departSelect;
  RxBool isFacultySelected = false.obs;
  RxBool isStudentSelected = false.obs;
  RxBool isEveryoneSelected = false.obs;
  RxBool isLoading = false.obs;

  final _name = TextEditingController();
  final _message = TextEditingController();
  final _noticeNo = TextEditingController();

  String? studentSelected;

  String? everyoneSelected;

  var uploadData;
  Future<void> addNoticeForManagement() {
    // Call the user's CollectionReference to add a new user
    var uploadData = NoticeModal(
        notice_no: _noticeNo.text,
        notice_message: _message.text,
        notice_title: _name.text,
        date_time: DateTime.now().toString(),
        read: false);
    return addNotice
        .doc("management")
        .collection('${managSelected}')
        .doc('all')
        .set(
      {
        "$managSelected": FieldValue.arrayUnion([uploadData.toMap()])
      },
      SetOptions(merge: true),
    ).catchError(
            (error) => Fluttertoast.showToast(msg: "Somethong went wrong"));
  }

  Future<void> addNoticeForFaculty() {
    // Call the user's CollectionReference to add a new user
    var uploadData = NoticeModal(
        notice_no: _noticeNo.text,
        notice_message: _message.text,
        notice_title: _name.text,
        date_time: DateTime.now().toString(),
        read: false);
    return addNotice
        .doc("faculty")
        .collection('${managSelected}')
        .doc(departSelected)
        .set(
      {
        "$departSelected": FieldValue.arrayUnion([uploadData.toMap()])
      },
      SetOptions(merge: true),
    ).catchError(
            (error) => Fluttertoast.showToast(msg: "Somethong went wrong"));
  }

  Future<void> addNoticeForEveryone() {
    // Call the user's CollectionReference to add a new user
    var uploadData = NoticeModal(
        notice_no: _noticeNo.text,
        notice_message: _message.text,
        notice_title: _name.text,
        date_time: DateTime.now().toString(),
        read: false);
    return addNotice.doc("All").set(
      {
        "everyone": FieldValue.arrayUnion([uploadData.toMap()])
      },
      SetOptions(merge: true),
    ).catchError(
        (error) => Fluttertoast.showToast(msg: "Somethong went wrong"));
  }

  Future<void> addNoticeForStudents() {
    // Call the user's CollectionReference to add a new user
    uploadData = NoticeModal(
        notice_no: _noticeNo.text,
        notice_message: _message.text,
        notice_title: _name.text,
        faculty: departSelected,
        date_time: DateTime.now().toString(),
        read: false);
    return addNotice
        .doc("students")
        .collection('notice')
        .doc(ctrl.selectedbatch.string)
        .collection(ctrl.facultySubject.string)
        .doc(ctrl.selectedSem.string)
        .set(
      {
        "students": FieldValue.arrayUnion([uploadData.toMap()])
      },
      SetOptions(merge: true),
    ).catchError(
            (error) => Fluttertoast.showToast(msg: "Somethong went wrong"));
  }

  clear() {
    _name.clear();
    _message.clear();
    _noticeNo.clear();
  }

  final List<String> items = [
    "Agriculture",
    "Library Science",
    "Arts, Commerce",
    "CS & IT",
    "Journalism & Mass Communication",
    "Zoology",
    "Psychology",
    "Mathematics",
    "Science"
  ];
  final List<String> management = [
    "Everyone",
    "Students",
    "Faculty",
    "Exam",
    "Result",
    "Admission",
    "Resource",
  ];
  FormTextCont formText = FormTextCont();
  var ctrl = Get.put(RadioController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.backgroundColor,
        appBar: AppBarScreen(title: "Release Notice"),
        body: Obx(() => isLoading.isFalse
            ? FutureBuilder<Object>(
                future: DefaultAssetBundle.of(context)
                    .loadString("assets/files/courses.json"),
                builder: (context, snapshot) {
                  try {
                    var myDataFromJson = json.decode(snapshot.data.toString());

                    if (snapshot.connectionState == ConnectionState.done) {
                      List<dynamic> jsondiplomaCourse =
                          myDataFromJson["Diploma"];
                      List<dynamic> jsonSemester = myDataFromJson["semester"];

                      List<dynamic> jsonug = myDataFromJson["UG"];
                      // print(jsonug);
                      List<dynamic> jsonpg = myDataFromJson["PG"];
                      // List<dynamic> jsoncateogery = myDataFromJson["cateogery"];
                      List<dynamic> jsonbatch = myDataFromJson["batch"];
                      // print(jsonpg);
                      List<dynamic> jsoncourse = myDataFromJson["course"];
                      return ui(jsonSemester, jsoncourse, jsondiplomaCourse,
                          jsonug, jsonpg, jsonbatch, context);
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Loading"),
                          Constant.circle(),
                        ],
                      );
                    }
                  } catch (e) {
                    print("Caught Error while fetching json: ");
                  }
                  ;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Loading"),
                      Constant.circle(),
                    ],
                  );
                })
            : Constant.circle()));
  }

  Widget ui(
      List<dynamic> jsonSemester,
      List<dynamic> jsoncourse,
      List<dynamic> jsondiplomaCourse,
      List<dynamic> jsonug,
      List<dynamic> jsonpg,
      jsonbatch,
      BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                formText.formText(
                    _noticeNo,
                    const Icon(Icons.person, color: Colors.black),
                    "Notice No",
                    [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    RequiredValidator(errorText: "Required"),
                    20,
                    TextInputType.number,
                    Colors.amber[300]),
                formText.formText(
                    _name,
                    const Icon(Icons.person, color: Colors.black),
                    "Title of Notice",
                    [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]+|\s'))
                    ],
                    RequiredValidator(errorText: "Required"),
                    20,
                    TextInputType.name,
                    Colors.amber[300]),
                formTextMulti(
                    _message,
                    const Icon(Icons.person, color: Colors.black),
                    "Message",
                    [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]+|\s+|\-+|\,'))
                    ],
                    RequiredValidator(errorText: "Required"),
                    150,
                    TextInputType.name,
                    Colors.amber[300],
                    6),
                dropDown(),
                Obx(() => Visibility(
                      visible: isStudentSelected.isTrue,
                      child: CourseDropDown(
                        jsonbatch: jsonbatch,
                        jsoncourse: jsoncourse,
                        jsondiplomaCourse: jsondiplomaCourse,
                        jsonpg: jsonpg,
                        jsonSemester: jsonSemester,
                        jsonug: jsonug,
                      ),
                    )),
                CustomButtonNew(
                    text: "Submit",
                    onPressed: () async {
                      if (formKey.currentState!.validate()
                          // &&ctrl.facultySubject.string != "" &&
                          // ctrl.selectedbatch.string != "" &&
                          // ctrl.selectedSem.string != "" &&
                          // ctrl.selected.string != ""
                          ) {
                        FocusScope.of(context).unfocus();
                        if (isFacultySelected.isFalse &&
                            isStudentSelected.isFalse &&
                            isEveryoneSelected.isFalse) {
                          isLoading.value = true;
                          await addNoticeForManagement()
                              .then((value) => isLoading.value = false);
                          clear();
                        } else if (isStudentSelected.isTrue) {
                          isLoading.value = true;
                          await addNoticeForStudents()
                              .then((value) => isLoading.value = false);
                          clear();
                        } else if (isFacultySelected.isTrue) {
                          isLoading.value = true;
                          await addNoticeForFaculty()
                              .then((value) => isLoading.value = false);
                          clear();
                        } else {
                          isLoading.value = true;
                          await addNoticeForEveryone()
                              .then((value) => isLoading.value = false);
                          clear();
                        }
                        print("check success");
                      } else {
                        isLoading.value = false;
                        print("check fails");
                        Constant.showSnackBar(
                            context, "* All Fields are required !");
                      }
                      print("Button Tapped");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formTextMulti(
      final TextEditingController controller,
      final Widget icon,
      final String label,
      final List<TextInputFormatter>? inputFormatters,
      final String? Function(String?)? validator,
      final int? maxLength,
      final TextInputType? keyboardType,
      final Color? color,
      final int? maxLine) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.newline,
        controller: controller,
        validator: validator,
        maxLines: maxLine,
        maxLength: maxLength! > 0 ? maxLength : 50,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 63)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDown() {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(right: 20, left: 16),
        width: width / 1.5,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return "Select Management";
              }
              return null;
            },
            value: managSelected,
            hint: const Text("Select Management"),
            items: management
                .map((item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)))
                .toList(),
            onChanged: (String? value) {
              if (value == "Faculty") {
                isStudentSelected.value = false;
                isFacultySelected.value = true;
                managSelected = value!;
              } else if (value == "Students") {
                isStudentSelected.value = true;
                isFacultySelected.value = false;
                setState(() {
                  studentSelected = value!;
                });
              } else if (value == "Everyone") {
                isStudentSelected.value = false;
                isFacultySelected.value = false;
                isEveryoneSelected.value = true;
                setState(() {
                  everyoneSelected = value!;
                });
              } else {
                isStudentSelected.value = false;
                isFacultySelected.value = false;
                debugPrint(value);
                debugPrint("value: ");
                setState(() {
                  managSelected = value!;
                });
              }
            },
            iconSize: 30,
            iconEnabledColor: Colors.yellow,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonWidth: 60,
            buttonPadding: const EdgeInsets.only(left: 16, right: 30),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.redAccent,
            ),
            buttonElevation: 2,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 16, right: 14),
            dropdownMaxHeight: 200,
            dropdownWidth: 200,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.redAccent,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(-20, 0),
          ),
        ),
      ),
      Obx(() => Visibility(
          visible: isFacultySelected.isTrue,
          child: Container(
            margin: const EdgeInsets.only(right: 20, left: 16),
            width: width / 1.5,
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return "Select departement";
                  }
                  return null;
                },
                value: departSelected,
                hint: const Text("Select Departement"),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                onChanged: (String? value) {
                  debugPrint(value);
                  debugPrint("value: ");
                  setState(() {
                    departSelected = value;
                  });
                },
                iconSize: 30,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonWidth: 60,
                buttonPadding: const EdgeInsets.only(left: 16, right: 30),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.redAccent,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 16, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.redAccent,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
          )))
    ]);
  }
}

//!==============================================

