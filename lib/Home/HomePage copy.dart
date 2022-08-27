import 'dart:async';

import 'package:aisect_custom/drawer/widget/navigation_drawer_widget.dart';
import 'package:aisect_custom/model/basicDataModal.dart';
import 'package:aisect_custom/routes/app_routes.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:aisect_custom/Exam_panel/Exams.dart';

import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/Result-Section/Results.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:aisect_custom/inside_resources/Resources.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/ExitDialog.dart';

class HomePage extends StatefulWidget {
  var ctrl;
  HomePage({Key? key, this.ctrl}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController semester = TextEditingController();
  TextEditingController rollno = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final FirebaseFirestore firestore;
  String task =
      "https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/StudentProfileImg%2FEEFEZxEPLoTm0byR3wJZVIyCIJ62%2Fimage_picker9094997287726926097.gif?alt=media&token=6c9e4b36-a9d9-4acb-b2d9-0bda4c66bb3c";
  String uid = "no user";
  // List items = ["2019", "2020", "2021"];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    // startNotification();
    retrieveData();

    // checkUserForFirst();
  }

  //

  var basicDataModal;
  var data;
  Future retrieveData() async {
    try {
      data = await retrieveStudentInfo();
      basicDataModal = BasicDataModal.fromMap(data);
      if (basicDataModal.isHomeVisited == false) {
        createUser();
        // updateVisit();
      } else {}
      // print(basicDataModal.semester);
      // print("in exam $data");
    } catch (e) {
      print("$e in init");
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionRef =
      _firestore.collection("batchWise");

  // static final CollectionReference _userCollectionRef1 =
  //     _firestore.collection("batchWise");
  //! creating user in BatchWise Collection
  Future createUser() async {
    try {
      await _userCollectionRef
          .doc(basicDataModal.batch)
          .collection(basicDataModal.semester)
          .doc(basicDataModal.faculty)
          .collection('StudentRollList')
          .doc(basicDataModal.examRoll)
          .set({
        'full name': basicDataModal.name,
        'Phone No': basicDataModal.phone,
        'email': "Enter Email",
        'Course': basicDataModal.faculty,
        'Discipline': "ex: UG,PG,Diploma",
        'ProfileUrl': task,
        'Roll': basicDataModal.examRoll,
        'Current_Semester': basicDataModal.semester,
        'Batch': basicDataModal.batch,
        'role': 'student'
      }).whenComplete(() => updateVisit());
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  static final CollectionReference _userUpdateVisit =
      _firestore.collection("Raw_students_info");

  //! creating user
  Future updateVisit() async {
    try {
      await _userUpdateVisit.doc(constuid).update(
        {'isHomeVisited': true},
      );
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future saveDatatoFB() async {
    retrieveData();
    Fluttertoast.showToast(msg: "Data Saved Sucess");
  }

  final List<String> titles = [
    "ADMISSION",
    "EXAMS",
    "RESULTS",
    "RESOURCES",
    "NOTICE",
  ];
  final List<IconData> icons = [
    CarbonIcons.add,
    CarbonIcons.exam_mode,
    CarbonIcons.activity,
    CarbonIcons.forum,
    CarbonIcons.activity,
    CarbonIcons.activity,
  ];
  final List<IconData> iconsForHeader = [
    CarbonIcons.home,
    CarbonIcons.user_profile,
    CarbonIcons.logout,
    CarbonIcons.notification_filled,
    CarbonIcons.information_square_filled,
    CarbonIcons.help_filled,
  ];
  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];

  final List<String> pageName = [
    "Home",
    "Profile",
    "Logout",
    "Notification",
    "About",
    "Help",
  ];
  final List<Widget> page = const [
    AdmissionHome(),
    ExamHome(),
    ResultHome(),
    ResourcesHome()
  ];
  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 11.59) {
      return 'Good Morning';
    } else if (timeNow > 12 && timeNow <= 16) {
      return 'Good Afternoon';
    } else if (timeNow > 16 && timeNow < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  bool isloading = false;
  RxBool _isloading = false.obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
          backgroundColor: const Color(0xffe7f0fd),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Aisect University",
                style: TextStyle(
                  fontSize: Constant.height / 32,
                )),
            toolbarHeight: Constant.height / 7,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.yellow.shade200],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
            ),
          ),
          drawer: NavigationDrawerWidget(),
          body: Consumer<ConnectivityProvider>(
              builder: (consumerContext, model, child) {
            if (model.isOnline) {
              return Obx(() => _isloading.isFalse
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: homeWidget(),
                    )
                  : Constant.circle());
            } else {
              return NoInternet();
            }
          })),
    );
  }

  Widget homeWidget() {
    widget cont = widget();

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 0),
              child: Text(
                "🖐 Appriciator,".toUpperCase(),
                style: TextStyle(
                    fontSize: Constant.height / 45,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: Constant.height / 60,
            ),
            Text(
              greetingMessage(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(
              height: Constant.height / 18,
            ),
            InkWell(
              child: cont.container(color, icons, titles, 0),
              onTap: () async {
                _isloading.value = true;
                // setState(() {});
                await Future.delayed(const Duration(milliseconds: 800));
                isloading = false;
                Navigator.pushNamed(context, AppRoutes.admissionHome);
                _isloading.value = false;
              },
            ),
            InkWell(
                child: cont.container(color, icons, titles, 1),
                onTap: () async {
                  _isloading.value = true;
                  await Future.delayed(const Duration(milliseconds: 800));

                  Navigator.pushNamed(context, AppRoutes.examHome);
                  _isloading.value = false;
                }),
            // glass.frostedGlassEffectDemo(context),
          ],
        ),
        SizedBox(
          width: Constant.width / 20,
        ),
        Padding(
          padding: EdgeInsets.only(top: Constant.height / 10, right: 10),
          child: Column(
            // direction: Axis.vertical,
            children: [
              InkWell(
                  child: cont.container(color, icons, titles, 2),
                  onTap: () async {
                    _isloading.value = true;
                    await Future.delayed(const Duration(milliseconds: 800));

                    Navigator.pushNamed(context, AppRoutes.ResultHome);
                    _isloading.value = false;
                  }),
              InkWell(
                  child: cont.container(color, icons, titles, 3),
                  onTap: () async {
                    _isloading.value = true;
                    await Future.delayed(const Duration(milliseconds: 800));

                    Navigator.pushNamed(context, AppRoutes.ResourceHome);
                    _isloading.value = false;
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () async {
                      _isloading.value = true;
                      await Future.delayed(const Duration(milliseconds: 800));

                      Navigator.pushNamed(context, AppRoutes.noticeStud);
                      _isloading.value = false;
                    },
                    child: Container(
                      height: Constant.height / 15,
                      width: Constant.width / 2.5,
                      decoration: BoxDecoration(
                        // color: Colors.grey,
                        gradient: LinearGradient(
                          colors: color[4],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 1.0],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[4]),
                          Text(titles[4]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
