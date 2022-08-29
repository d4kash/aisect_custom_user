import 'dart:async';
import 'package:aisect_custom/admissionOnStart/drawer/widget/navigation_drawer_widget_admiss.dart';
import 'package:aisect_custom/drawer/widget/navigation_drawer_widget.dart';
import 'package:aisect_custom/inside_Admis/course.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/inside_Admis/Apply.dart';

import 'package:aisect_custom/inside_Admis/Enquiry.dart';
import 'package:aisect_custom/inside_Admis/status.dart';
import 'package:animations/animations.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdmissionHome extends StatefulWidget {
  const AdmissionHome({Key? key}) : super(key: key);

  @override
  _AdmissionHomeState createState() => _AdmissionHomeState();
}

class _AdmissionHomeState extends State<AdmissionHome> {
  @override
  void initState() {
    super.initState();
  }

  final cont = Get.put(widget());

  bool innerBoxScrolled = true;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: NavigationDrawerWidgetAdmission(),

      body: containerBox(context),

      // ),
    );
  }

  containerBox(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
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
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const EnquiryForm();
                },
              ),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 1);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const Fee();
                },
              ),
              // OpenContainer(
              //   transitionType: ContainerTransitionType.fadeThrough,
              //   closedColor: const Color(0xffe7f0fd),
              //   openColor: const Color(0xffe7f0fd),
              //   middleColor: const Color(0xffe7f0fd),
              //   closedElevation: 0.0,
              //   openElevation: 4.0,
              //   transitionDuration: const Duration(milliseconds: 800),
              //   closedBuilder: (BuildContext context, void Function() action) {
              //     return cont.container(color, icons, titles, 2);
              //   },
              //   openBuilder: (BuildContext context,
              //       void Function({Object? returnValue}) action) {
              //     return UserInformation();
              //   },
              // ),
            ],
          ),
          SizedBox(
            width: width / 38,
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 10),
            child: Column(children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 2);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const ApplyForAdmission();
                },
              ),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 3);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return ApplicationStatus(); //! For timeline
                },
              ),
              // OpenContainer(
              //   transitionType: ContainerTransitionType.fadeThrough,
              //   closedColor: const Color(0xffe7f0fd),
              //   openColor: const Color(0xffe7f0fd),
              //   middleColor: const Color(0xffe7f0fd),
              //   closedElevation: 0.0,
              //   openElevation: 4.0,
              //   transitionDuration: const Duration(milliseconds: 800),
              //   closedBuilder: (BuildContext context, void Function() action) {
              //     return cont.container(color, icons, titles, 4);
              //   },
              //   openBuilder: (BuildContext context,
              //       void Function({Object? returnValue}) action) {
              //     return AcceptedCandidate(); //! For PaperVerification
              //   },
              // ),
              containerForText(),
            ]),
          ),
        ]));
  }

  Widget containerForText() {
    return SizedBox(child: Container());
  }

  final List<String> titles = [
    "INQUIRY",
    "COURSE & FEE",
    "APPLY",
    "STATUS",
  ];
  final List<IconData> icons = [
    CarbonIcons.add,
    CarbonIcons.exam_mode,
    Icons.add_box,
    Icons.speed,
  ];
  final List<Widget> page = [
    const EnquiryForm(),
    const Fee(),
    const ApplyForAdmission(),
    ApplicationStatus()
  ];

  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
  ];

  Widget container(final List<List<Color>> color, final List<IconData> icons,
      final List<String> titles, final int index, List<Widget> page) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 20),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            child: Container(
              height: Get.size.height / 3.3,
              width: Get.size.width / 2.5,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                // color: Colors.grey,
                gradient: LinearGradient(
                  colors: color[index],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    size: Get.size.height / 18,
                  ),
                  SizedBox(
                    height: Get.size.height / 25,
                  ),
                  Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: Get.size.height / 35,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              // _timer?.cancel();
              // await Future.delayed(const Duration(seconds: 3));
              // await EasyLoading.show(status: 'building...');
              // EasyLoading.dismiss();
              Get.to(() => page[index]);
            },
          ),
        ),
      ]),
    );
  }
}
//  _timer?.cancel();
//                   await EasyLoading.show(status: 'loading...');
//                   await Future.delayed(const Duration(seconds: 3));

//                   EasyLoading.dismiss();
//                   Get.to(() => const EnquiryForm());
