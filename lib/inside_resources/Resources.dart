import 'dart:async';

import 'package:aisect_custom/widget/containerWidget.dart';

import 'package:aisect_custom/inside_resources/grievance_form.dart';
import 'package:aisect_custom/inside_resources/study_notes.dart';
import 'package:aisect_custom/inside_resources/syllabus.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:animations/animations.dart';
import 'package:carbon_icons/carbon_icons.dart';

import 'package:flutter/material.dart';

class ResourcesHome extends StatefulWidget {
  const ResourcesHome({Key? key}) : super(key: key);

  @override
  _ResourcesHomeState createState() => _ResourcesHomeState();
}

class _ResourcesHomeState extends State<ResourcesHome> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(
          title: 'Resources',
        ),
        body: Hero(
          tag: "RESOURCES",
          child: resultContainer(context),
        ));
  }

  resultContainer(BuildContext context) {
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
                  return page[0];
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
                  return page[1];
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
              return page[2];
            },
          )
        ]));
  }

  final List<Widget> page = const [
    Syllabus(),
    StudyNotes(),
    GrievanceForm(),
    // UploadSyllabus(),
    // UploadNotes()
  ];
  final List<String> titles = [
    "SYLLABUS",
    "STUDY NOTES",
    "COMPLAINT FORM",
    // "UPLOAD SYLLABUS",
    // "UPLOAD NOTES",
  ];
  final List<IconData> icons = [
    CarbonIcons.notebook,
    CarbonIcons.notebook,
    CarbonIcons.activity,
    // CarbonIcons.forum,
    // CarbonIcons.forum,
  ];

  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    // [Color(0xFF8E97C2), Color(0xFFB064CE)],
    // [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];
}
