import 'dart:async';

import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/Result-Section/getResult.dart';
import 'package:aisect_custom/Result-Section/revaluation.dart';
import 'package:animations/animations.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultHome extends StatefulWidget {
  const ResultHome({Key? key}) : super(key: key);

  @override
  _ResultHomeState createState() => _ResultHomeState();
}

class _ResultHomeState extends State<ResultHome> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Result ",
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
      body: Hero(
        tag: "RESULTS",
        child: Container(
          child: resultContainer(context),
        ),
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
                  return const GetResult();
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
                  return const Revaluation();
                },
              ),
            ],
          )
        ]));
  }

  final List<String> titles = [
    "GET RESULT",
    "RE-VALUATION",
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
