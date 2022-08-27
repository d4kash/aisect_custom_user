import 'package:aisect_custom/widget/DropDown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetController/theme_controller.dart';

class CourseDropDown extends StatelessWidget {
  final List<dynamic> jsonSemester,
      jsoncourse,
      jsondiplomaCourse,
      jsonug,
      jsonpg,
      jsonbatch;
  const CourseDropDown(
      {Key? key,
      required this.jsonSemester,
      required this.jsoncourse,
      required this.jsondiplomaCourse,
      required this.jsonug,
      required this.jsonpg,
      required this.jsonbatch})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    RxBool visible = false.obs;
    RadioController ctrl = Get.put(RadioController());
    return Column(
      children: [
        DropDown(
          listforDropDown: jsonbatch,
          onRadioSelectedForCourse: (value) {
            ctrl.selectedbatch.value = value;
            print(ctrl.selectedbatch);
            FocusScope.of(context).unfocus();
          },
          string: 'Current Batch'.toUpperCase(),
        ),
        DropDown(
          listforDropDown: jsonSemester,
          onRadioSelectedForCourse: (value) {
            ctrl.selectedSem.value = value;
            print(ctrl.selectedSem);
            FocusScope.of(context).unfocus();
          },
          string: 'Current Semester'.toUpperCase(),
        ),
        DropDown(
          listforDropDown: jsoncourse,
          onRadioSelectedForCourse: (value) {
            ctrl.selected.value = value;

            if (value == "UG") {
              ctrl.selectedFaculty.value = jsonug;
              ctrl.update();
            } else if (value == "PG") {
              ctrl.selectedFaculty.value = jsonpg;
              ctrl.update();
            } else {
              ctrl.selectedFaculty.value = jsondiplomaCourse;
              ctrl.update();
            }
            print(ctrl.selectedFaculty);
            // selected.value =
            //     checking(value, jsonug, jsonpg, jsondiplomaCourse);
            // print(selected);
            print(ctrl.selected);
            visible.value = true;
            // ctrl.selectedFaculty.value = ctrl.selectCourse(
            //     value, jsonug, jsonpg, jsondiplomaCourse);
            FocusScope.of(context).unfocus();
          },
          string: 'Current Stream'.toUpperCase(),
        ),
        GetBuilder<RadioController>(
          init: RadioController(),
          initState: (_) {},
          builder: (ctrl) {
            return faculty(
              ctrl.selectedFaculty,
              ctrl.selected.string,
            );
          },
        ),
      ],
    );
  }

  Widget faculty(
    List jsonug,
    String value,
  ) {
    RadioController ctrl = Get.put(RadioController());
    if (value == "Diploma") {
      return GetBuilder<RadioController>(
        init: RadioController(),
        initState: (_) {},
        builder: (_) {
          return DropDown(
            listforDropDown: jsonug,
            string: "select faculty ".toUpperCase(),
            onRadioSelectedForCourse: (value) async {
              print(value + "faculty");
              ctrl.facultySubject.value = value;
              print(ctrl.facultySubject.string);

              // ctrl.update();
            },
          );
        },
      );
    } else if (value == "UG") {
      return DropDown(
        listforDropDown: jsonug,
        string: "select faculty ".toUpperCase(),
        onRadioSelectedForCourse: (value) async {
          print(value + "faculty");
          ctrl.facultySubject.value = value;
          print(ctrl.facultySubject.string);
    
        },
      );
    } else if (value == "PG") {
      return GetBuilder<RadioController>(
        init: RadioController(),
        initState: (_) {},
        builder: (_) {
          return DropDown(
              listforDropDown: jsonug,
              string: "select faculty ".toUpperCase(),
              onRadioSelectedForCourse: (value) async {
                print(value + "faculty");
                ctrl.facultySubject.value = value;
                print(ctrl.facultySubject.string);

              });
        },
      );
    } else {
      return Container();
    }
  }
}
