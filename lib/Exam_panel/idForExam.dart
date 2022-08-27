import 'dart:convert';

import 'package:aisect_custom/Home/app_colors.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

// import 'package:velocity_x/velocity_x.dart';
import 'package:delayed_display/delayed_display.dart';

class IdForOnlineExam extends StatefulWidget {
  const 
  IdForOnlineExam({Key? key}) : super(key: key);

  @override
  _ApplicationStatusState createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends State<IdForOnlineExam> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  // final TextEditingController _name = TextEditingController();

  final TextEditingController _aadharno = TextEditingController();

  final TextEditingController _dob = TextEditingController();
  // final _examRollNo = TextEditingController();
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');

  DateTime currentDate = DateTime.now();
  final dateFormat = DateFormat('dd-MM-yyyy');
  Future<Null> _selectDate(BuildContext context) async {
    final _selecteddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2022));

    if (_selecteddate != null && _selecteddate != currentDate) {
      setState(() {
        currentDate = _selecteddate;
        _dob.text = dateFormat.format(_selecteddate);
      });
    }
  }

  bool _visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  bool visiblity = false;
  String namefromjson = "null";
  String semesterfromjson = "null";
  String userIdfromjson = "null";
  String passwordfromjson = "null";
  var confData;
  // FocusNode? aadhar;

  StepperType stepperType = StepperType.vertical;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _aadharno.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // aadhar = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(title: "Get Admit Card"),
        body: containerforId(
          context,
        ),
      ),
    );
  }

  Column containerforId(BuildContext context) {
    // print(myDataFromJson.runtimeType);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Form(
              key: key,
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 50,
                        child: CupertinoTextFormFieldRow(
                            // focusNode: FocusScope.of(context),
                            maxLength: 12,
                            keyboardType: TextInputType.phone,
                            controller: _aadharno,
                            placeholder: "Aadhar No",
                            decoration: const BoxDecoration(
                                color: AppColors.formColor1),
                            validator: (val) {
                              if (!aadharRegex.hasMatch(val!)) {
                                return "Not Valid aadhar";
                              }
                              return null;
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CupertinoButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            print("okk done");
                            print("object");

                            _toggle();
                          } else {
                            Fluttertoast.showToast(
                                msg: "All Fields are required",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: const Text("Get Info"),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 200,
                  color: Colors.lightBlue[700],
                  child: FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString("assets/files/idpass.json"),
                      builder: (context, snapshot) {
                        var myDataFromJson =
                            json.decode(snapshot.data.toString());

                        if (snapshot.connectionState == ConnectionState.done) {
                          confData = matchData(myDataFromJson, _aadharno.text);
                          if (confData == _aadharno.text) {
                            namefromjson = myDataFromJson[confData]["name"];
                            semesterfromjson =
                                myDataFromJson[confData]["semester"];
                            userIdfromjson = myDataFromJson[confData]["UserId"];
                            passwordfromjson =
                                myDataFromJson[confData]["password"];
                            return DelayedDisplay(
                              delay: const Duration(milliseconds: 800),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Name :    $namefromjson",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Semester:       $semesterfromjson",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "UserId:      $userIdfromjson",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Password:$passwordfromjson",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const DelayedDisplay(
                              delay: Duration(milliseconds: 800),
                              slidingCurve: Curves.elasticInOut,
                              slidingBeginOffset: Offset(0, 0.25),
                              child: Center(
                                  child: Text(
                                "No data Found or Incorrect aadhar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )),
                            );
                          }
                        } else {
                          return const Center(
                            widthFactor: 0.5,
                            heightFactor: 0.5,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String matchData(Map<String, dynamic> xyz, String aadharNo) {
    var data;
    var confData = "253672821871";
    xyz.forEach((key, value) {
      if (key != "id") {
        data = key;
      } else {
        print("object");
      }
      if (data == aadharNo) {
        confData = data;
      } else {
        print("no data found");
        // abc = "No Data Found";
        // confData = "no data found";
      }
      print(data);
    });
    return confData;
  }
}
