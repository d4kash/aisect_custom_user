import 'dart:convert';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/utils/image_links.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../GetController/theme_controller.dart';
import '../widget/containerWidget.dart';
import '../firebase_helper/FirebaseConstants.dart';
import '../widget/CourseSelection.dart';
import 'package:aisect_custom/services/LocalData.dart';

import '../widget/appBar.dart';
import '../widget/customButton.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  List items = ["2019", "2020", "2021", "2022", "2023", "2024"];
  var _yearController;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController rollno = TextEditingController();
  String uid = "no user";
  RxList courseList = [].obs;
  var ctrl = Get.put(RadioController());

  @override
  void initState() {
    checkallpermission_openstorage();

    super.initState();
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionUpdate =
      _firestore.collection("Raw_students_info");
  Future updateVisit() async {
    try {
      await _userCollectionUpdate.doc(constuid).update(
        {'isHomeVisited': true},
      );
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: "Complete Profile"),
      body: Obx(() => ctrl.isLoading.isFalse
          ? FutureBuilder(
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
                    return body(jsonSemester, jsoncourse, jsondiplomaCourse,
                        jsonug, jsonpg, jsonbatch);
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Loading"),
                    Constant.circle(),
                  ],
                );
              })
          : Constant.circle()),
    );
  }

  Widget body(
    List<dynamic> jsonSemester,
    List<dynamic> jsoncourse,
    List<dynamic> jsondiplomaCourse,
    List<dynamic> jsonug,
    List<dynamic> jsonpg,
    jsonbatch,
  ) {
    FormTextCont cons = FormTextCont();
    return Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          reverse: false,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: <Widget>[
              Lottie.network(CompleteProfile1),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                    text: "Enter Correct Details \n",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "\n This can't be editable later, Be Careful")
                    ]),
              ),
              CourseDropDown(
                jsonbatch: jsonbatch,
                jsoncourse: jsoncourse,
                jsondiplomaCourse: jsondiplomaCourse,
                jsonpg: jsonpg,
                jsonSemester: jsonSemester,
                jsonug: jsonug,
              ),
              cons.formText(
                  name,
                  const Icon(Icons.person, color: Colors.black),
                  "Name",
                  [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+|\s'))],
                  RequiredValidator(errorText: "Required"),
                  20,
                  TextInputType.name,
                  Colors.amber[300]),
              cons.formText(
                  phoneNo,
                  const Icon(Icons.person, color: Colors.black),
                  "Phone Number",
                  [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  RequiredValidator(errorText: "starts with 6"),
                  10,
                  TextInputType.number,
                  Colors.amber[300]),
              cons.formText(
                  rollno,
                  const Icon(Icons.person, color: Colors.black),
                  "Roll Number",
                  [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                  RequiredValidator(errorText: "Required"),
                  12,
                  TextInputType.name,
                  Colors.amber[300]),
              const SizedBox(height: 20),
              CustomButton(
                icon: CarbonIcons.save,
                text: "save",
                onPressed: () async {
                  if (_key.currentState!.validate() &&
                      ctrl.facultySubject.string != "" &&
                      ctrl.selectedbatch.string != "" &&
                      ctrl.selectedSem.string != "" &&
                      ctrl.selected.string != "") {
                    FocusScope.of(context).unfocus();
                    Constant.faculty = ctrl.facultySubject.string;
                    ctrl.isLoading.value = true;
                    createUser(ctrl); //creating user inraw_student_info
                    // updateVisit(); //updating isHomeVisited
                    // setState(() {});
                    await Future.delayed(const Duration(milliseconds: 500));
                    ctrl.isLoading.value = false;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePageNav(ctrl: ctrl.facultySubject.string)),
                        (route) => false);
                  } else {
                    Constant.showSnackBar(context, "* required");
                  }
                },
              ),
              SizedBox(height: Constant.height / 40),
              // MaterialButton(
              //   color: Colors.deepOrangeAccent,
              //   shape: const StadiumBorder(),
              //   onPressed: () async {
              //     if (_key.currentState!.validate() &&
              //         ctrl.facultySubject.string != "" &&
              //         ctrl.selectedbatch.string != "" &&
              //         ctrl.selectedSem.string != "" &&
              //         ctrl.selected.string != "") {
              //       FocusScope.of(context).unfocus();
              //       Constant.faculty = ctrl.facultySubject.string;
              //       ctrl.isLoading.value = true;
              //       createUser(ctrl); //creating user inraw_student_info
              //       updateVisit(); //updating isHomeVisited
              //       // setState(() {});
              //       Future.delayed(const Duration(milliseconds: 500));
              //       ctrl.isLoading.value = false;
              //       Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //                   HomePage(ctrl: ctrl.facultySubject.string)),
              //           (route) => false);
              //     } else {
              //       Constant.showSnackBar(context, "* required");
              //     }
              //   },
              //   child: const Text(
              //     "SAVE",
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // )
            ],
          ),
        ));
  }
//checking Permission==========

  checkallpermission_openstorage() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      initializeUser();
    } else {
      Fluttertoast.showToast(msg: "Provide Storage permission to use storage.");
    }
  }

  checkpermission_openstorage() async {
    var storageStatus = await Permission.camera.status;
    // var microphoneStatus = await Permission.microphone.status;

    print(storageStatus);
    // print(microphoneStatus);
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission.
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission.
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission.
    //cameraStatus.isUndetermined == permission has not asked before.

    if (!storageStatus.isGranted) await Permission.storage.request();

    // if (!microphoneStatus.isGranted) await Permission.microphone.request();

    if (await Permission.storage.isGranted) {
    } else {
      Fluttertoast.showToast(
        msg: "Provide storage permission to use storage.",
      );
    }
  }

  //!Getting user Id from firebase auth
  Future initializeUser() async {
    // final User? firebaseUser = FirebaseAuth.instance.currentUser;
    // // await firebaseUser!.reload();

    // if (firebaseUser != null) {
    //   final user = firebaseUser.uid;

    //   uid = user.toString();
    //   // await callJson();
    //   // print(user.toString());
    //   // print(" initilalized user from HomePage: ${uid}");
    //   // print(" initilalized user from HomePage: ${Constant.name}");
    //   // print(" initilalized user from HomePage: ${Constant.phone}");
    // }

    // await FirebaseAuth.instance.signOut();
  }

  static final CollectionReference _userCollectionRef =
      _firestore.collection("Raw_students_info");

  //! creating user
  Future createUser(var ctrl) async {
    try {
      await LocalData.saveFaculty(ctrl.facultySubject.string);

      await _userCollectionRef.doc(constuid).set({
        'name': name.text,
        'phone': phoneNo.text,
        'batch': ctrl.selectedbatch.string,
        'semester': ctrl.selectedSem.string,
        'ExamRoll': rollno.text.toUpperCase(),
        'Faculty': ctrl.facultySubject.string,
        'isHomeVisited': false,
        'role': 'student'
      }, SetOptions(merge: true));
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }
}
