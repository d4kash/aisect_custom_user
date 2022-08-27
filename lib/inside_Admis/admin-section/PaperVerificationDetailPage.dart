// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:aisect_custom/model/statusModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../GetController/theme_controller.dart';
import '../../firebase_helper/FirebaseConstants.dart';
import '../../model/AdmissionModal.dart';
import '../../services/constant.dart';
import '../../widget/appBar.dart';
import '../../widget/containerWidget.dart';
import '../../widget/customDialog.dart';

class PaperVerificationDetail extends StatelessWidget {
  final String id;

  RxInt _toggleValue = 0.obs;

  PaperVerificationDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  var modal;
  Map<String, dynamic>? storedata;
  var token;
  FormTextCont textField = FormTextCont();
  var _marksheetNo = TextEditingController();
  var _recieptno = TextEditingController();
  var _assignRoll = TextEditingController();
  var _verifier = TextEditingController();
  var _assignBatch = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  // RxBool _switchValue = false.obs;
  List<Map> documentList = [
    {"name": "Is aadhar verified*", "isChecked": false},
    {"name": "Is CLC verified*", "isChecked": false},
    {
      "name": "Is Marksheet verified*",
      "isChecked": false,
    },
    {"name": "Is Character certificate verified*", "isChecked": false},
    {"name": "Is Payment Done required", "isChecked": false},
  ];
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("Accepted_Admission_Application");
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBarScreen(
        title: id,
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: _usersCollectionReference.doc("$id").get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Center(
                child: Text("Enjoy! :) you have no work for now"),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              modal = AdmissionModal.fromMap(data);
              storedata = data;

              return SingleChildScrollView(
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //? give me more data
                      SizedBox(
                        height: Constant.height / 35,
                      ),
                      // showDataFromDB(data, context),
                      ExpansionTile(
                        title: Text("Details"),
                        children: [showDataFromDB(data, context)],
                      ),
                      // showDataFromDB(data, context),
                      Text(
                        'List of Documents to be verified: ',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(
                        height: Constant.height / 30,
                      ),

                      GetBuilder<RadioController>(
                        init: RadioController(),
                        initState: (_) {},
                        builder: (ctrl) {
                          return Column(
                              children: documentList.map((hobby) {
                            return CheckboxListTile(
                                value: hobby["isChecked"],
                                title: Text(hobby["name"]),
                                onChanged: (newValue) {
                                  // setState(() {
                                  ctrl.updateCheckBox(newValue);
                                  hobby["isChecked"] = ctrl.switchValue.value;
                                  // });
                                });
                          }).toList());
                        },
                      ),

                      SizedBox(height: 20),
                      textField.formText(
                          _marksheetNo,
                          const Icon(Icons.numbers, color: Colors.black),
                          "Enter Marksheet Number",
                          [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]+|\s'))
                          ],
                          RequiredValidator(errorText: "Required"),
                          25,
                          TextInputType.name,
                          Colors.amber[300]),
                      SizedBox(height: 20),
                      textField.formText(
                          _recieptno,
                          const Icon(Icons.numbers, color: Colors.black),
                          "Payment Reciept no",
                          [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]+|\s'))
                          ],
                          RequiredValidator(errorText: "Required"),
                          25,
                          TextInputType.name,
                          Colors.amber[300]),
                      SizedBox(height: 20),
                      textField.formText(
                          _assignRoll,
                          const Icon(Icons.numbers, color: Colors.black),
                          "assign roll no",
                          [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]+|\s'))
                          ],
                          RequiredValidator(errorText: "Required"),
                          25,
                          TextInputType.name,
                          Colors.amber[300]),
                      SizedBox(height: 20),
                      textField.formText(
                          _assignBatch,
                          const Icon(Icons.numbers, color: Colors.black),
                          "assign Batch",
                          [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]+|\s'))
                          ],
                          RequiredValidator(errorText: "Required"),
                          25,
                          TextInputType.name,
                          Colors.amber[300]),
                      SizedBox(height: 20),
                      textField.formText(
                          _verifier,
                          const Icon(Icons.person, color: Colors.black),
                          "Verifier Name",
                          [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]+|\s'))
                          ],
                          RequiredValidator(errorText: "Required"),
                          25,
                          TextInputType.name,
                          Colors.amber[300]),
                      SizedBox(height: 20),
                      Text("* If not availabe leave box untick"),
                      SizedBox(height: 20),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrangeAccent,
                              textStyle: TextStyle(fontSize: 25)),
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              // token = generateRandomString();
                              addAdmissionApplication(data);
                              updateinAdmission();
                              showDialog(
                                  context: context,
                                  builder: (_) => AdvanceDialog(
                                        s: "Application added with \n Roll no : \"${_assignRoll.text}\"",
                                        title: "Seat Alloted ",
                                      ));
                            } else {
                              Constant.showSnackBar(
                                  context, "all fields are required");
                            }
                          },
                          child: Text("Allot Seat")),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
              // return Text("Full Name: ${data['full name']}");
            }

            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Constant.circle(),
                Text("loading"),
              ],
            ));
          }
          // Future that needs to be resolved
          // inorder to display something on the Canvas

          ),
    );
  }

  final CollectionReference trackadmissionApplication =
      FirebaseFirestore.instance.collection("track_Admission_Application");
  Future<void> trackApp() {
    var trackUpload = StatusModal(
        document_verified: true,
        isRoll_assigned: true,
        token: modal.token,
        status: 3,
        assignedRoll: _assignRoll.text,
        verifyTime: Constant.time(),
        verifyDate: Constant.date());
    return trackadmissionApplication.doc(constuid).update(trackUpload.toMap());
  }

  // TextField_resultBx box = TextField_resultBx();
  Widget showDataFromDB(Map<String, dynamic> data, context) {
    var listForData = [
      {'label': 'Name', 'value': modal.full_name},
      {'label': 'D.O.B', 'value': modal.D_O_B},
      {'label': 'Father\'s name', 'value': modal.father_name},
      {'label': 'mother\'s name', 'value': modal.mother_name},
      {'label': 'aadhar no', 'value': modal.Aadhar_No},
      {'label': 'Emaiil', 'value': modal.Email},
      {'label': 'Phone no', 'value': modal.Phone_No},
      {'label': 'Discipline', 'value': modal.Discipline},
      {'label': 'Course', 'value': modal.Course},
      {'label': 'Village', 'value': modal.Vill},
      {'label': 'Post office', 'value': modal.PO},
      {'label': 'District', 'value': modal.District},
      {'label': 'State', 'value': modal.State},
      {'label': 'Last exam qualified', 'value': modal.Last_Exam_Qualified},
      {'label': 'Exam Roll no', 'value': modal.Exam_Roll_NO},
      {'label': 'Percentage Secured', 'value': modal.Percent},
      {'label': 'Board', 'value': modal.board},
      {'label': 'Token Number', 'value': modal.token},
    ];
    // var modal = AdmissionModal.fromMap(data);
    // TextDisplay display = TextDisplay();
    return Container(
      height: Constant.height / 1.5,
      width: Constant.width,
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: listForData.length,
          itemBuilder: (BuildContext context, int index) {
            return TextField_resultBx(
              borderLabelTextBox: listForData[index]['label'],
              // boxResultTitle: '',
              displayBoxResult: listForData[index]['value'],
            );
          }),
    );
  }

//=================================
//updatingin appliedForAdmissionfinal CollectionReference admissionApplication =
  final CollectionReference NewadmissionApplication =
      FirebaseFirestore.instance.collection("New_Admission_Application");
  Future<void> updateinAdmission() {
    return NewadmissionApplication.doc(
            "${modal.full_name} : applied for ${modal.Course}")
        .delete();
  }

//================================
  //================================================================
  //If application accepted
  //================================================================
  final CollectionReference admissionApplication =
      FirebaseFirestore.instance.collection("Verified_Admission_Application");

  Future<void> addAdmissionApplication(Map<String, dynamic> data) {
    // Call the user's CollectionReference to add a new user
    var uploadData = AdmissionModal(
        full_name: modal.full_name,
        D_O_B: modal.D_O_B,
        father_name: modal.father_name,
        mother_name: modal.mother_name,
        Email: modal.Email,
        Phone_No: modal.Phone_No,
        Aadhar_No: modal.Aadhar_No,
        Course: modal.Course,
        Discipline: modal.Discipline,
        Vill: modal.Vill,
        PO: modal.PO,
        District: modal.District,
        State: modal.State,
        Pincode: modal.Pincode,
        Exam_Roll_NO: modal.Exam_Roll_NO,
        Last_Exam_Qualified: modal.Last_Exam_Qualified,
        Percent: modal.Percent,
        board: modal.board,
        status: 3,
        token: token,
        Marksheet_no: _marksheetNo.text.trim(),
        Reciept_no: _recieptno.text.trim(),
        batch: _assignRoll.text.trim(),
        verifier_name: _verifier.text.trim());
    return admissionApplication
        .doc("$token")
        // .doc(
        //     "${storedata!["full_name"]} : applied for ${storedata!["selecteddiscipline"]}")
        .set(uploadData.toMap())
        .catchError((error) => Fluttertoast.showToast(msg: "$error"));
  }

  //----------------------------------------------------

  //=====================
  //==Generate token For accepted application

  String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@#&';
    return List.generate(7, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
