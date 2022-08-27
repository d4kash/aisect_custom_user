import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleDarkMode(bool x) {
    isDarkMode.value = x;
    if (isDarkMode.value == true) {
      ThemeData.dark();
    } else {
      ThemeData.light();
    }
    update();
  }
}

class Const {
  // RadioController ctr = RadioController();
  // var data = ctr.data.value;
}

class RadioController extends GetxController {
  RxInt value = 3.obs; //fee
  RxInt sub = 30.obs; //fee
  RxString coursedata = "null".obs; //fee class
  RxString facultydata2 = "null".obs; //feeclass
  var selectedFaculty = [].obs;
  var selected = "".obs;
  var selectedSem = "".obs;
  var selectedbatch = "".obs;
  RxString result = "".obs;
  RxString facultySubject = "".obs;
  RxString paymentStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxBool switchValue = false.obs;
 
  void updateCheckBox(bool? value) {
    // setState(() {
    switchValue.value = value!;
    update();
    print(switchValue);
    // });
  }

  void getExamSubject(Map<String, dynamic> myDataFromJson) {
    try {
      result.value = matchData(
          myDataFromJson, facultySubject.string + " " + selectedSem.string);

      update();
    } catch (e) {
      print("caught error: $e");
      result.value = "Selected Semester is not valid for this course";
      update();
    }
  }

  void onItemSelect(int index, Map<String, dynamic> myDataFromJson) {
    value.value = index;
    coursedata.value =
        matchData(myDataFromJson, "${myDataFromJson["course"][value.value]}");

    update();
  }

  void onSubSelect(int index, Map<String, dynamic> myDataFromJson) {
    sub.value = index;
    facultydata2.value = matchData(
        myDataFromJson, "${myDataFromJson[coursedata.value][sub.value]}");

    update();
  }

  String matchData(Map<String, dynamic> xyz, String course) {
    String data = "";
    var confData = "null";
    xyz.forEach((key, value) {
      if (key != "id") {
        data = key;
      } else {
        print("object");
      }
      if (data == course) {
        confData = data;
      } else {
        print("no data found");
        // abc = "No Data Found";
        // confData = "no data found";
      }
      // print(data);
    });
    return confData;
  }
}
