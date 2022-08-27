import 'dart:convert';

import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/model/basicDataModal.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/DynamicTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aisect_custom/GetController/theme_controller.dart';

import '../firebase_helper/FirebaseConstants.dart';
import '../payment/RazorPay.dart';
import '../widget/appBar.dart';

class Revaluation extends StatefulWidget {
  const Revaluation({Key? key}) : super(key: key);

  @override
  _RevaluationFormState createState() => _RevaluationFormState();
}

class _RevaluationFormState extends State<Revaluation> {
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  var data; //Getting data
  RadioController ctrl = Get.put(RadioController());
  FormTextCont textBox = FormTextCont(); //For TextField
  var controller = Get.put(RadioController()); //For CheckingStatus
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference revaluationRequest =
      FirebaseFirestore.instance.collection("revaluation_Request");

  Future<void> addRevaluationrequest() {
    // Call the user's CollectionReference to add a new user
    return revaluationRequest
        .doc(basicDataModal.examRoll)
        .collection(basicDataModal.faculty)
        .doc(basicDataModal.batch)
        .set({
          'name': basicDataModal.name, // John Doe
          'phone': basicDataModal.phone,
          'subject code': Constant.revaluationData,
          'payment': 'Sucess'
        })
        .then(
          (value) => clearTextInput(),
        )
        .catchError((error) => print("Failed to add user: $error"));
  }

  clearTextInput() {}

  @override
  void dispose() {
    super.dispose();
  }

  // Future getDocs() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("Raw_students_info").get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //     print(a.id);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    //double height1 = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: 'Revaluation Form'),
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
              return examwidget(context, jsonSemester, jsoncourse,
                  jsondiplomaCourse, jsonug, jsonpg, jsonbatch);
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
              Constant.circle(),
              SizedBox(
                height: Constant.height / 55,
              ),
              const Text("Loading.."),
            ],
          );
        },
      ),
    );
  }

  var basicDataModal;
  Future retrieveData() async {
    try {
      data = await retrieveStudentInfo();
      basicDataModal = BasicDataModal.fromMap(data);
      setState(() {});
      // print(basicDataModal.semester);
      // print("in exam $data");
    } catch (e) {
      print("$e in init");
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
    return SingleChildScrollView(
        reverse: false,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
                height: Constant.height / 2, child: const DynamicTextField()),
            SizedBox(height: Constant.height / 35),
            OutlinedButton(
                onPressed: () async {
                  if (Constant.revaluationData.length != null) {
                    print(Constant.revaluationData.length);
                    var amount = Constant.revaluationData.length * 50;
                    debugPrint(Constant.revaluationData.length.toString());
                    debugPrint(amount.toString());
                    await Get.to(() => RazorPay(
                          name: data['name'],
                          phone: data['phone'],
                          amount: amount.toString(),
                          data: data,
                        ));
                    if (controller.paymentStatus.string == "Success") {
                      await addRevaluationrequest();
                    } else {
                      Constant.showSnackBar(
                          context, "payment Failed. Please retry");
                    }
                  } else {
                    print(Constant.revaluationData.length);
                    Constant.showSnackBar(
                        context, "Please fill subject code for revaluation");
                  }
                },
                child: const Text("Make Payment")),
            SizedBox(height: Constant.height / 35),
            RichText(
              text: const TextSpan(
                  text:
                      "* Note : You have to pay Rs 50/ Subject for revaluation",
                  style: TextStyle(color: Colors.orange)),
            ),
            SizedBox(height: Constant.height / 30),
          ],
        ));
  }
}
