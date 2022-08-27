import 'package:aisect_custom/Exam_panel/Exam_Form.dart';
import 'package:aisect_custom/Exam_panel/TimeTable.dart';
import 'package:aisect_custom/Exam_panel/examForm.dart';
import 'package:aisect_custom/Exam_panel/idForExam.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:animations/animations.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

class ExamHome extends StatefulWidget {
  const ExamHome({Key? key}) : super(key: key);

  @override
  _ExamHomeState createState() => _ExamHomeState();
}

class _ExamHomeState extends State<ExamHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(
        title: "Exam ",
      ),
      body: Hero(
        tag: "EXAMS",
        child: examContainer(context),
      ),
    );
  }

  examContainer(BuildContext context) {
    widget cont = widget();
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Wrap(children: [
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
                  return const ExamFormNew();
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
                  return const IdForOnlineExam();
                },
              ),
            ],
          ),
          SizedBox(
            width: Constant.width / 18,
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
              return cont.container(color, icons, titles, 2);
            },
            openBuilder: (BuildContext context,
                void Function({Object? returnValue}) action) {
              return const TimeTable();
            },
          )
        ]));
  }

  final List<String> titles = [
    "EXAM FORM",
    "ADMIT CARD",
    "TIME TABLE",
    // "UPLOAD SCHEDULE",
  ];
  final List<IconData> icons = [
    CarbonIcons.add,
    CarbonIcons.exam_mode,
    CarbonIcons.activity,
    // CarbonIcons.forum,
  ];
  final List<Widget> page = const [
    ExamForm(),
    IdForOnlineExam(),
    TimeTable(),
    // UploadSchedule()
  ];

  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    // [Color(0xffaccbee), Color(0xFFC3D5EE)],
    // [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];
}
