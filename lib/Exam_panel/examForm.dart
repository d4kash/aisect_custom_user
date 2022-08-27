import 'dart:convert';

import 'package:aisect_custom/model/basicDataModal.dart';
import 'package:aisect_custom/payment/paytm_config.dart';
import 'package:aisect_custom/payment/paytm_payment.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../GetController/theme_controller.dart';
import '../widget/containerWidget.dart';
import '../firebase_helper/FirebaseConstants.dart';
import '../model/examModel.dart';
import '../payment/RazorPay.dart';
import '../services/constant.dart';
import '../widget/CourseSelection.dart';
import '../widget/appBar.dart';

class ExamFormNew extends StatefulWidget {
  const ExamFormNew({Key? key}) : super(key: key);

  @override
  State<ExamFormNew> createState() => _ExamFormNewState();
}

class _ExamFormNewState extends State<ExamFormNew> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 500) {
          return const WebForm();
        } else {
          return const MobileForm();
        }
      },
    );
  }
}

//
class WebForm extends StatefulWidget {
  const WebForm({Key? key}) : super(key: key);

  @override
  State<WebForm> createState() => _WebFormState();
}

class _WebFormState extends State<WebForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(title: 'Exam'),
        body: Container(child: const Text("data")));
  }
}

//
class MobileForm extends StatefulWidget {
  const MobileForm({Key? key}) : super(key: key);

  @override
  State<MobileForm> createState() => _MobileFormState();
}

class _MobileFormState extends State<MobileForm> {
  FormTextCont cons = FormTextCont();

  var selected = [].obs;
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp yearRegex = RegExp(r'^(201[0-9]|20[2-4]\d|200\d|2040)');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  RxBool isDataLoading = false.obs;

  var basicDataModal;
  @override
  void dispose() {
    // TODO: implement dispose
    Get.reset();
    super.dispose();
  }

  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: 'Exam Form'),
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
              // List<dynamic> jsoncateogery = myDataFromJson["cateogery"];
              List<dynamic> jsonbatch = myDataFromJson["batch"];
              // print(jsonpg);
              List<dynamic> jsoncourse = myDataFromJson["course"];
              return Obx(() => isDataLoading.isTrue
                  ? examwidget(context, jsonSemester, jsoncourse,
                      jsondiplomaCourse, jsonug, jsonpg, jsonbatch)
                  : Constant.circle());
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
            print("Caught Error while fetching json: $e");
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Loading"),
              Constant.circle(),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  Future retrieveData() async {
    data = await retrieveStudentInfo();
    if (data != null) {
      basicDataModal = BasicDataModal.fromMap(data);
      isDataLoading.value = true;
      print("in exam $data");
    }
  }

//called from Scaffold
  Widget examwidget(
    BuildContext context,
    List<dynamic> jsonSemester,
    List<dynamic> jsoncourse,
    List<dynamic> jsondiplomaCourse,
    List<dynamic> jsonug,
    List<dynamic> jsonpg,
    jsonbatch,
  ) {
    print("in exam $data");
    // RxBool visible = false.obs;
    // RadioController ctrl = Get.put(RadioController());
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        child: SingleChildScrollView(
            reverse: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.name, "Name"),
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.examRoll, "Roll"),
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.phone, "Phone"),
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.batch, "Batch"),
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.faculty, "Subject"),
                SizedBox(height: Constant.height / 55),
                SizedBox(height: Constant.height / 55),
                loadedtextBox(basicDataModal.semester, "Semester"),
                SizedBox(height: Constant.height / 55),
                CourseDropDown(
                  jsonbatch: jsonbatch,
                  jsoncourse: jsoncourse,
                  jsondiplomaCourse: jsondiplomaCourse,
                  jsonpg: jsonpg,
                  jsonSemester: jsonSemester,
                  jsonug: jsonug,
                ),
                ExamTable(
                  data: basicDataModal,
                ),
              ],
            )),
      ),
    );
  }

//!ReBuilds Faculty ui

}

//Creates Table
class ExamTable extends StatefulWidget {
  var data;
  ExamTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ExamTable> createState() => _ExamTableState();
}

class _ExamTableState extends State<ExamTable> {
  @override
  Widget build(BuildContext context) {
    var list = [].obs;
    var practicaldetails;
    var genericElective;
    RxBool subjectListSelected = false.obs;
    RadioController ctrl = Get.put(RadioController());
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/files/subjectcode.json"),
        builder: (context, AsyncSnapshot snapshot) {
          try {
            var myDataFromJson = json.decode(snapshot.data.toString());

            if (snapshot.connectionState == ConnectionState.done) {
              // var result = matchData(myDataFromJson, "Bachelor's in Commerce 1");
              // var details = ExamModel.fromMap(myDataFromJson[result]);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  // _buildTableRow(list),
                  Obx(() => _buildTableRow(list)),
                  SizedBox(
                    height: Constant.height / 25,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CustomButtonNew(
                      text: "Subject List",
                      onPressed: () async {
                        try {
                          // print("touched" " k");
                          ctrl.getExamSubject(myDataFromJson);
                          print(ctrl.facultySubject.string +
                              " " +
                              ctrl.selectedSem.string);
                          print(ctrl.result.string);
                          var details = ExamModel.fromMap(
                              myDataFromJson[ctrl.result.string]);
                          // print(myDataFromJson[ctrl.result.string]
                          //     .len); //calling ExamModel & adding to List
                          if (myDataFromJson[ctrl.result.string]['Practical'] !=
                              null) {
                            practicaldetails = ExamModel.fromMapPractical(
                                myDataFromJson[ctrl.result.string]
                                    ['Practical']);
                          } else {} //calling ExamModel & adding to List
                          if (myDataFromJson[ctrl.result.string]
                                  ['Generic Elective'] !=
                              null) {
                            genericElective = ExamModel.fromMapPractical(
                                myDataFromJson[ctrl.result.string]
                                    ['Generic Elective']);
                          } else {} //calling ExamModel & adding to List

                          list.value = [
                            details.a,
                            details.b,
                            details.c,
                            details.d,
                            details.e,
                            details.f,
                            details.g,
                            details.h,
                            details.i,
                            details.j,
                            details.k,
                            "Generic Elective : ",
                            practicaldetails.a ?? '',
                            practicaldetails.b ?? '',
                            practicaldetails.c ?? '',
                            practicaldetails.d ?? '',
                            practicaldetails.e ?? '',
                            practicaldetails.f ?? '',
                            practicaldetails.g ?? '',
                            "Practical : ",
                            practicaldetails.a ?? '',
                            practicaldetails.b ?? '',
                            practicaldetails.c ?? '',
                            practicaldetails.d ?? '',
                            practicaldetails.e ?? '',
                            practicaldetails.f ?? '',
                            practicaldetails.g ?? '',
                            practicaldetails.h ?? '',
                            practicaldetails.i ?? '',
                            practicaldetails.j ?? '',
                            practicaldetails.k ?? '',
                          ];
                          subjectListSelected.value = true;
                          if (subjectListSelected.isTrue) {
                            _buildTableRow(list);
                          }
                        } catch (e) {
                          print("caught error: $e");
                          Constant.showSnackBar(
                              context, "Select valid details for this course");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: Constant.height / 60,
                  ),
                  Obx(() => Visibility(
                        visible: subjectListSelected.isTrue,
                        child: CustomButtonNew(
                          text: "Checkout",
                          onPressed: () async {
                            // var token = Constant.generateRandomString();
                            // print(token);
                            await PaytmPayment.initiateTransaction(
                                "1000", context);
                            // await saveExamFormToDB(data);
                            // Get.to(() => RazorPay(
                            //       name: data['name'],
                            //       phone: data["phone no"],
                            //       amount: '1000',
                            //       data: data,
                            //     ));
                            // } else {
                            //   Constant.showSnackBar(context,
                            //       "Please click on Subject List first");
                            //   Fluttertoast.showToast(msg: 'select');
                            // }
                          },
                        ),
                      )),
                ]),
              );
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
            print(e.toString() + "error");
          }
          return const Text("something went wrong");
        });
  }

  Future saveExamFormToDB(var data) async {
    try {
      print(data.batch);
      var collection =
          FirebaseFirestore.instance.collection('ExamApply_Section');
      return collection
          .doc(data.batch)
          .collection(data.semester)
          .doc(data.faculty)
          .collection('StudentRollList')
          .doc(data.examRoll)
          .set({
        'name': data.name,
        'phone': data.phone,
        'transaction_no': '',
        'status': 'pending',
      }).then((value) => Get.defaultDialog(
              title: "Confirmation",
              content: Text("Exam Form Submittd,\nWe'll confirm status soon")));
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildTableRow(
    List item,
  ) {
    final re = RegExp(r':');
    // item.indexWhere((element) => element == "").;
    item.removeWhere((element) => element == "");
    // print(updatedList);

    try {
      return Container(
        padding: const EdgeInsets.all(15),
        child: Table(
          //if data is loaded then show table
          border: TableBorder.all(width: 1, color: Colors.black45),
          children: item.map((nameone) {
            var subjectcode = nameone.split(re);
            // var subjectname = nameone.split(re)[1];
            // print(subjectcode);
            // print(nameone.split(re)[1]);
            //display data dynamically from namelist List.
            return TableRow(//return table row in every loop
                children: [
              //table cells inside table row

              TableCell(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(subjectcode[0]))),
              TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(5), child: Text(subjectcode[1]))),
            ]);
          }).toList(),
        ),
      );
    } catch (e) {
      return Container(
        child: Text("error: $e"),
      );
    }
  }
}
