import 'dart:async';
import 'dart:math';

import 'package:aisect_custom/notice/notice-admin/notice_admin.dart';
import 'package:aisect_custom/notice/notice_section.dart';
import 'package:aisect_custom/notification/notification_service.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/Result-Section/getResult.dart';
import 'package:aisect_custom/Result-Section/revaluation.dart';
import 'package:animations/animations.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import '../firebase_helper/FirebaseConstants.dart';

class NoticeHome extends StatefulWidget {
  const NoticeHome({Key? key}) : super(key: key);

  @override
  _NoticeHomeState createState() => _NoticeHomeState();
}

class _NoticeHomeState extends State<NoticeHome> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Notice ",
            style: TextStyle(
              fontSize: Constant.height / 25,
            )),
        toolbarHeight: Get.size.height / 7,
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
      body: Container(
        child: resultContainer(context),
      ),
    );
  }

  resultContainer(BuildContext context) {
    widget cont = widget();
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Row(children: [
          Column(
            children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 0);
                },
                openBuilder: (BuildContext context, action) {
                  return NoticeStudent();
                  //Add GetResult();
                  // _timer?.cancel();
                  // await EasyLoading.show(status: 'loading...');
                  // await Future.delayed(const Duration(milliseconds: 800));
                  // EasyLoading.dismiss();
                  // Get.to(() => const GetResult());
                },
              ),
            ],
          ),
          SizedBox(
            width: Get.size.width / 25,
          ),
          Column(
            children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 1);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return NoticeAdminHome();
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    print('tapped');
                    await onClick();
                    startNotification();
                  },
                  child: Text('click'))
            ],
          )
        ]));
  }

  startNotification() async {
    Workmanager().registerOneOffTask(
      "fetch22",
      "fetchBackground",
      inputData: {
        'int': 1,
        'bool': true,
        'double': 1.0,
        'string': 'string',
        'array': [1, 2, 3],
      },
    );
  }

  

  // await Workmanager().registerPeriodicTask(
  //   "1",
  //   "fetchBackground",
  //   frequency: Duration(minutes: 15),
  //   // constraints: Constraints(
  //   //   networkType: NetworkType.connected,
  //   //   requiresBatteryNotLow: true,
  //   // ),
  // );
  //   print('done');
  // }

  onClick() async {
    var random = Random();
    debugPrint(" in workmanager");
    final _notificationService = NotificationService();

    var _auth = await FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      var noticeList = await FirestoreMethods.getNoticeStudents();

      noticeList.students.forEach((notification) async {
        if (notification.read == false) {
          // Fluttertoast.showToast(msg: '${notification.notice_no}');
          await _notificationService.showNotifications(random.nextInt(1000),
              notification.notice_title, notification.notice_message);
        }
        // Fluttertoast.showToast(msg: '${notification.notice_no}');
      });
    } else {
      await _notificationService.showNotifications(12, "AISECT UNIVERSITY",
          " Welcome to our family,\nwe are happy to serve you");
    }
  }

  final List<String> titles = [
    "Notice",
    "Notice admin",
  ];
  final List<IconData> icons = [
    CarbonIcons.ai_results,
    CarbonIcons.exam_mode,
    // CarbonIcons.activity,
    // CarbonIcons.forum,
  ];
  final List<Widget> page = [const GetResult(), const Revaluation()];
  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    // [Color(0xff2af598), Color(0xff009efd)],
    // [Color(0xffaccbee), Color(0xFFC3D5EE)],
    // [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];
}
