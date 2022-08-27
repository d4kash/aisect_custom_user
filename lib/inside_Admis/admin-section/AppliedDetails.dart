// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:aisect_custom/inside_Admis/admin-section/GetAppliedList.dart';
import 'package:aisect_custom/model/statusModal.dart';
import 'package:aisect_custom/widget/customDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../GetController/date_controller.dart';
import '../../firebase_helper/FirebaseConstants.dart';
import '../../model/AdmissionModal.dart';
import '../../services/constant.dart';
import '../../widget/appBar.dart';
import '../../widget/containerWidget.dart';

class IdDetailsPage extends GetView<DateController> implements Bindings {
  final String id;

  var textEditingController;
  IdDetailsPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  var modal;
  Map<String, dynamic>? storedata;
  var token;
  final formKey = GlobalKey<FormState>();
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("New_Admission_Application");
  var data;
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<DateController>(
      () => DateController(),
    );
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
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //? give me more data

                    showDataFromDB(data, context),
                    SizedBox(height: 20),
                    Text("Allot date to student for document verification : "),
                    SizedBox(height: 20),

                    Obx(
                      () => Container(
                        height: height / 15,
                        width: width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.green, spreadRadius: 3),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            controller.chooseDate();
                          },
                          child: IgnorePointer(
                            child: Center(
                              child: Text(
                                DateFormat("dd-MM-yyyy")
                                    .format(controller.selectedDate.value)
                                    .toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                textStyle: TextStyle(fontSize: 25)),
                            onPressed: () {},
                            child: Text("Reject")),
                        SizedBox(width: 30),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrangeAccent,
                                textStyle: TextStyle(fontSize: 25)),
                            onPressed: () {
                              addAdmissionApplication(data);
                              updateinAdmission();
                              trackApp();
                              showDialog(
                                  context: context,
                                  builder: (_) => AdvanceDialog(
                                        s: "Application added with \n Token no : \"${modal.token}\"",
                                        title: "Accepted",
                                        pageName: UserInformation(),
                                      ));
                            },
                            child: Text("Accept")),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
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
        appl_accepted: true,
        token: token,
        status: 2,
        assignedRoll: '',
        acceptTime: Constant.time(),
        acceptDate: Constant.date(),
        verifyTime: '',
        verifyDate: '',
        allotedDate: controller.selectedDate.value.toString());
    return trackadmissionApplication.doc(constuid).update(trackUpload.toMap()
        //   {
        //   'status': 2,
        //   'assignedRoll': '',
        //   'acceptTime': Constant.time(),
        //   'acceptDate': Constant.date()
        // }
        );
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Container(
        height: Constant.height / 1.8,
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
      ),
    );
  }

//=================================
//updatingin appliedForAdmissionfinal CollectionReference admissionApplication =
  final CollectionReference NewadmissionApplication =
      FirebaseFirestore.instance.collection("New_Admission_Application");
  Future<void> updateinAdmission() {
    return NewadmissionApplication.doc(
            "${modal.full_name} : applied for ${modal.Course}")
        .update({
      'status': 2,
    });
  }

//================================
  //================================================================
  //If application accepted
  //================================================================
  final CollectionReference admissionApplication =
      FirebaseFirestore.instance.collection("Accepted_Admission_Application");

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
        status: 2,
        token: modal.token);
    return admissionApplication
        .doc(modal.token)
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
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(6, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

/**binding  */
  @override
  void dependencies() {
    Get.lazyPut<DateController>(
      () => DateController(),
    );
  }
}
