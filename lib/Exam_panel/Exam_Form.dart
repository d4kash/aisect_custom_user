//! \\ Submitting Application to fbdb

// import 'package:aisect_custom/inside_Admis/Courses_Fee.dart';
import 'dart:convert';

import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/widget/DropDown.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/login/services/pdf.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/customDialog.dart';
// import 'package:aisect_custom/widget/drop_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

import '../widget/containerWidget.dart';

class ExamForm extends StatefulWidget {
  const ExamForm({Key? key}) : super(key: key);

  @override
  _ApplyForAdmissionState createState() => _ApplyForAdmissionState();
}

class _ApplyForAdmissionState extends State<ExamForm> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    // GlobalKey<FormState>(),
    // GlobalKey<FormState>(),
  ];

  // final _formKeycourse = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _mname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _aadharno = TextEditingController();
  final TextEditingController _phoneno = TextEditingController();
  final TextEditingController _vill = TextEditingController();
  final TextEditingController _poffice = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _lastexamQual = TextEditingController();
  final TextEditingController _percent = TextEditingController();
  final TextEditingController _board = TextEditingController();
  final TextEditingController _boardRoll1 = TextEditingController();
  final TextEditingController _boardRollCode = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final _examRollNo = TextEditingController();

  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');

  var Cateogery;
  var Semesterforbd;
  var coursefordb;
  var disciplinefordb;
  var selectedCourse;
  var selecteddiscipline;
  List<dynamic> selected = [];
  DateTime currentDate = DateTime.now();
  final dateFormat = DateFormat('dd-MM-yyyy');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "no User";
  User? _user;

  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser!.uid;
    _user = _auth.currentUser;
    setState(() {
      uid = _user!.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    initializeUser();
  }

  CollectionReference examForm =
      FirebaseFirestore.instance.collection("ExamForm");

  Future<void> addexamformApplication() {
    // Call the user's CollectionReference to add a new user
    return examForm.doc(uid).set({
      'full_name': _name.text,
      'father_Name': _fname.text,
      'mother_Name': _mname.text,
      'cateogery': Cateogery,
      'Email': _email.text,
      'Aadhar_No': _aadharno.text,
      'Phone_No': _phoneno.text,
      'Vill': _vill.text,
      'Post Office': _poffice.text,
      'District': _district.text,
      'State': _state.text,
      'Pincode': _pincode.text,
      'semester': Semesterforbd,
      'Last_Exam_Qualified': _lastexamQual.text,
      'Percent': _percent.text,
      'board': _board.text,
      // 'Board_Roll': _boardRoll1,
      'Exam_Roll_NO': _examRollNo.text,
      'board_Roll_Code': _boardRollCode.text,
      'D_O_B': _dob.text,
      'Selected Course': coursefordb,
      'Selected Discipline': disciplinefordb,
      // Stokes and Sons
    }).catchError((error) => Fluttertoast.showToast(msg: "$error"));
  }

  clearTextInput() {
    _name.clear();
    _dob.clear();
    _fname.clear();
    _aadharno.clear();
    _board.clear();
    _boardRoll1.clear();
    _boardRollCode.clear();
    _email.clear();
    _percent.clear();
    _lastexamQual.clear();
    _poffice.clear();
    _district.clear();
    _phoneno.clear();
    _pincode.clear();
    _state.clear();
    _vill.clear();
    _mname.clear();
    _examRollNo.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _dob.dispose();
    _fname.dispose();
    _aadharno.dispose();
    _board.dispose();
    _boardRoll1.dispose();
    _boardRollCode.dispose();
    _email.dispose();
    _percent.dispose();
    _lastexamQual.dispose();
    _poffice.dispose();
    _district.dispose();
    _phoneno.dispose();
    _pincode.dispose();
    _state.dispose();
    _vill.dispose();
    _mname.dispose();
    super.dispose();
  }

  Future _selectDate(BuildContext context) async {
    final _selecteddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1995),
        lastDate: DateTime(2050));

    if (_selecteddate != null && _selecteddate != currentDate) {
      setState(() {
        currentDate = _selecteddate;
        _dob.text = dateFormat.format(_selecteddate);
      });
    }
  }

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  @override
  Widget build(BuildContext context) {
    // FormText cons = FormText();

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Exam Form",
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
          // resizeToAvoidBottomInset: false,
          body: Consumer<ConnectivityProvider>(
              builder: (consumerContext, model, child) {
            return model.isOnline
                ? FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString("assets/files/courses.json"),
                    builder: (context, AsyncSnapshot snapshot) {
                      var myDataFromJson =
                          json.decode(snapshot.data.toString());

                      if (snapshot.connectionState == ConnectionState.done) {
                        List<dynamic> jsondiplomaCourse =
                            myDataFromJson["Diploma"];
                        List<dynamic> jsonSemester =
                            myDataFromJson["semester"];

                        List<dynamic> jsonug = myDataFromJson["UG"];
                        // print(jsonug);
                        List<dynamic> jsonpg = myDataFromJson["PG"];
                        List<dynamic> jsoncateogery =
                            myDataFromJson["cateogery"];
                        // print(jsonpg);
                        List<dynamic> jsoncourse = myDataFromJson["course"];
                        return nestedScrollView(
                            context,
                            jsonSemester,
                            jsoncourse,
                            jsondiplomaCourse,
                            jsonug,
                            jsonpg,
                            jsoncateogery);
                      } else {
                        return Center(
                          child: Column(
                            children: const [
                              Text("Loading"),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }
                    },
                  )
                : NoInternet();

            return Center(
              child: SpinKitDoubleBounce(),
            );
          }),
        ));
    //);
  }

  Widget nestedScrollView(
      BuildContext context,
      List<dynamic> jsonSemester,
      List<dynamic> jsoncourse,
      List<dynamic> jsondiplomaCourse,
      List<dynamic> jsonug,
      List<dynamic> jsonpg,
      jsoncateogery) {
    FormTextCont cons = FormTextCont();
    return Container(
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Stepper(
                type: stepperType,
                physics: const BouncingScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  final isLastStep = _currentStep == 3;
                  return Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: continued,
                        child: Text(isLastStep ? 'SUBMIT' : 'NEXT'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: cancel,
                        child: Text(isLastStep ? "Go back" : 'CANCEL'),
                      ),
                    ],
                  );
                },
                steps: <Step>[
                  Step(
                    title: const Text('Personal Details'),
                    content: Form(
                      key: _formKeys[0],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          cons.formText(
                              _name,
                              const Icon(Icons.person, color: Colors.black),
                              "Name", [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]+|\s'))
                          ], (val) {
                            if (val.isEmptyOrNull) {
                              return "Required";
                            }
                            return null;
                          }, 25, TextInputType.name, Colors.amber[300]),
                          cons.formText(
                              _fname,
                              const Icon(Icons.person, color: Colors.black),
                              "Father's Name",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "Required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          cons.formText(
                              _mname,
                              const Icon(Icons.person, color: Colors.black),
                              "Mother's Name",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "Required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectDate(context);
                                });
                              },
                              child: IgnorePointer(
                                child: cons.formText(
                                    _dob,
                                    const Icon(Icons.person,
                                        color: Colors.black),
                                    "D.O.B",
                                    [],
                                    RequiredValidator(errorText: "Required"),
                                    25,
                                    TextInputType.name,
                                    Colors.amber[300]),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: CustomDropdown(
                          //     text: "cateogery",
                          //     cateogery: jsoncateogery,
                          //     onItemSelect: (value) {
                          //       print(
                          //           "ojson ${jsoncateogery.elementAt(value)}");
                          //     },
                          //   ),
                          // child: DropDown(
                          //     listforDropDown: jsoncateogery,
                          //     string: "cateogery",
                          //     onRadioSelectedForCourse: (value) {
                          //       setState(() {
                          //         if (value != "cateogery") {
                          //           Cateogery = value;
                          //         } else {
                          //           Fluttertoast.showToast(
                          //               msg: "All Fields are required",
                          //               toastLength: Toast.LENGTH_SHORT,
                          //               gravity: ToastGravity.BOTTOM,
                          //               timeInSecForIosWeb: 1,
                          //               backgroundColor: Colors.red,
                          //               textColor: Colors.white,
                          //               fontSize: 16.0);
                          //         }
                          //         print('Cateogery: $Cateogery');
                          //       });
                          //     }),
                          // ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Address'),
                    content: Form(
                      key: _formKeys[1],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          children: const <Widget>[
                            //   cons.formText(
                            //     _vill,
                            //     const Icon(Icons.person, color: Colors.black),
                            //     "Vill : ",
                            //     [
                            //       FilteringTextInputFormatter.allow(
                            //           RegExp(r'[a-zA-Z]+|\s'))
                            //     ],
                            //     RequiredValidator(errorText: "Required"),
                            //     25,
                            //     TextInputType.name,
                            //     Colors.amber[300],
                            //   ),
                            //   cons.formText(
                            //     _poffice,
                            //     const Icon(Icons.person, color: Colors.black),
                            //     "post Office ",
                            //     [
                            //       FilteringTextInputFormatter.allow(
                            //           RegExp(r'[a-zA-Z]+|\s'))
                            //     ],
                            //     RequiredValidator(errorText: "Required"),
                            //     25,
                            //     TextInputType.name,
                            //     Colors.amber[300],
                            //   ),
                            //   cons.formText(
                            //     _district,
                            //     const Icon(Icons.person, color: Colors.black),
                            //     "District",
                            //     [
                            //       FilteringTextInputFormatter.allow(
                            //           RegExp(r'[a-zA-Z]+|\s'))
                            //     ],
                            //     RequiredValidator(errorText: "Required"),
                            //     25,
                            //     TextInputType.name,
                            //     Colors.amber[300],
                            //   ),
                            //   cons.formText(
                            //     _state,
                            //     const Icon(Icons.person, color: Colors.black),
                            //     "State",
                            //     [
                            //       FilteringTextInputFormatter.allow(
                            //           RegExp(r'[a-zA-Z]+|\s'))
                            //     ],
                            //     RequiredValidator(errorText: "Required"),
                            //     25,
                            //     TextInputType.name,
                            //     Colors.amber[300],
                            //   ),
                            //   cons.formText(
                            //   _pincode,
                            //   const Icon(Icons.person, color: Colors.black),
                            //   "pincode",
                            //   [],
                            //   RequiredValidator(errorText: "Required"),
                            //   6,
                            //   TextInputType.name,
                            //   Colors.amber[300],
                            // )
                          ],
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Education Qualification'),
                    content: Form(
                      key: _formKeys[2],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          //! For Course Selection

                          //?ForSemester
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            // child: CustomDropdown(
                            //   text: "Semester",
                            //   cateogery: jsonSemester,
                            //   onItemSelect: (value) {
                            //     print("ojson ${jsonSemester.elementAt(value)}");
                            //     if (jsonSemester.elementAt(value) !=
                            //         "Semester") {
                            //       Semesterforbd.value =
                            //           jsonSemester.elementAt(value);
                            //     } else {
                            //       Fluttertoast.showToast(
                            //           msg: "All Fields are required",
                            //           toastLength: Toast.LENGTH_SHORT,
                            //           gravity: ToastGravity.BOTTOM,
                            //           timeInSecForIosWeb: 1,
                            //           backgroundColor: Colors.red,
                            //           textColor: Colors.white,
                            //           fontSize: 16.0);
                            //     }
                            //     print('Semesterforbd: $Semesterforbd');
                            //   },
                            // ),
                            child: DropDown(
                              listforDropDown: jsonSemester,

                              string: "Semester",

                              onRadioSelectedForCourse: (value) {
                                setState(() {
                                  if (value != "Semester") {
                                    Semesterforbd = value;
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
                                  print('Semesterforbd: $Semesterforbd');
                                });
                              },
                              // String: "Select Sem",
                            ),
                          ),
                          // //@ for Selection Of course
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            // child: CustomDropdown(
                            //   text: "course",
                            //   cateogery: jsoncourse,
                            //   onItemSelect: (value) {
                            //     print("ojson ${jsoncourse.elementAt(value)}");
                            //     if (jsoncourse.elementAt(value) !=
                            //         "Choose Course") {
                            //       selecteddiscipline.value = "null".toString();

                            //       // print(value.runtimeType);
                            //       if (jsoncourse.elementAt(value) ==
                            //           "Diploma") {
                            //         selected.value = jsondiplomaCourse;
                            //       } else if (jsoncourse.elementAt(value) ==
                            //           "UG") {
                            //         selected.value = jsonug;
                            //       } else {
                            //         selected.value = jsonpg;
                            //       }

                            //       coursefordb.value = value;
                            //     }
                            //   },
                            // ),
                            child: DropDown(
                              listforDropDown: jsoncourse,
                              string: "Choose Course",
                              onRadioSelectedForCourse: (value) {
                                if (value != "Choose Course") {
                                  selecteddiscipline = null;

                                  // print(value.runtimeType);
                                  if (value == "Diploma") {
                                    selected = jsondiplomaCourse;
                                  } else if (value == "UG") {
                                    selected = jsonug;
                                  } else {
                                    selected = jsonpg;
                                  }

                                  setState(() {
                                    coursefordb = value;
                                  });
                                }
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            // child: CustomDropdown(
                            //   text: "sub-course",
                            //   cateogery: selected,
                            //   onItemSelect: (value) {
                            //     print("ojson ${selected.elementAt(value)}");

                            //     if (selected.elementAt(value) != "Discipline") {
                            //       disciplinefordb.value =
                            //           selected.elementAt(value);
                            //     } else {
                            //       Fluttertoast.showToast(
                            //           msg: "All Fields are required",
                            //           toastLength: Toast.LENGTH_SHORT,
                            //           gravity: ToastGravity.BOTTOM,
                            //           timeInSecForIosWeb: 1,
                            //           backgroundColor: Colors.red,
                            //           textColor: Colors.white,
                            //           fontSize: 16.0);
                            //     }
                            //   },
                            // ),
                            child: DropDown(
                              listforDropDown: selected,
                              string: "Discipline",
                              onRadioSelectedForCourse: (value) {
                                // print("$value on Exam Form for discipline");

                                setState(() {
                                  if (value != "Discipline") {
                                    disciplinefordb = value;
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
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: cons.formText(
                              _lastexamQual,
                              const Icon(Icons.person, color: Colors.black),
                              "Last Exam Qualified",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "Required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: cons.formText(
                                _examRollNo,
                                const Icon(Icons.person, color: Colors.black),
                                "Roll No",
                                [],
                                RequiredValidator(errorText: "Required"),
                                25,
                                TextInputType.name,
                                Colors.amber[300]),
                          ),
                          cons.formText(
                            _percent,
                            const Icon(Icons.person, color: Colors.black),
                            "Percentage Gained",
                            [
                              //FilteringTextInputFormatter.digitsOnly,
                            ],
                            RequiredValidator(errorText: "Required"),
                            5,
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            Colors.amber[300],
                          ),

                          cons.formText(
                            _board,
                            const Icon(Icons.person, color: Colors.black),
                            "Board",
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z]+|\s'))
                            ],
                            RequiredValidator(errorText: "Required"),
                            25,
                            TextInputType.name,
                            Colors.amber[300],
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Mobile Number'),
                    content: Form(
                      key: _formKeys[3],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: cons.formText(
                              _phoneno,
                              const Icon(Icons.person, color: Colors.black),
                              "Mobile",
                              [
                                // FilteringTextInputFormatter.allow(RegExpMatch(phoneRegex)),
                              ],
                              (val) {
                                if (!phoneRegex.hasMatch(val!)) {
                                  return "Not Valid";
                                }
                                return null;
                              },
                              25,
                              TextInputType.name,
                              Colors.amber[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: cons.formText(
                              _aadharno,

                              const Icon(Icons.person, color: Colors.black),
                              "Aadhar No", [],
                              (val) {
                                if (!aadharRegex.hasMatch(val!)) {
                                  return "Not Valid";
                                }
                                return null;
                              },
                              25,
                              TextInputType.name,
                              Colors.amber[300],
                              // validator: RequiredValidator(
                              //     errorText: "Required"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: cons.formText(
                              _email,

                              const Icon(Icons.person, color: Colors.black),
                              "Email Id",
                              [],
                              // RequiredValidator(errorText: "@required"),
                              EmailValidator(errorText: "not valid"),
                              25, TextInputType.name, Colors.amber[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ]),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 18.0),
          //   child: ConfirmationSlider(
          //       text: "Slide to Submit",
          //       height: 60,
          //       width: 250,
          //       backgroundColorEnd: Colors.grey.shade700.withOpacity(0.5),
          //       onConfirmation: () {
          //         if (_formKeys[_currentStep].currentState!.validate()) {
          //           _createPdf();
          //           addexamformApplication();
          //           clearTextInput();
          //           Semesterforbd = "semester";
          //           coursefordb = "course";
          //           disciplinefordb = "Discipline";
          //           showDialog(
          //             context: context,
          //             builder: (_) => AdvanceDialog(
          //               title: Text("Sucess"),
          //               s: "Exam Form Submited for sem $Semesterforbd",
          //             ),
          //           );
          //         } else {
          //           Fluttertoast.showToast(
          //               msg: "All Fields are required",
          //               toastLength: Toast.LENGTH_SHORT,
          //               gravity: ToastGravity.BOTTOM,
          //               timeInSecForIosWeb: 1,
          //               backgroundColor: Colors.red,
          //               textColor: Colors.white,
          //               fontSize: 16.0);
          //         }
          //       }),
          // ),
        ],
      ),
    );
  }

  Future<void> _createPdf() async {
//     // Create a new PDF document.
    final PdfDocument document = PdfDocument();
    final page1 = document.pages.add();
    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = Rect.fromLTWH(0, 30, page1.graphics.clientSize.width, 30);
    // PdfBrush rect1 = PdfBorders() ;

//Draws a rectangle to place the heading in that region
    page1.graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);
//Draws a line at the bottom of the address

//Creates a text element to add the invoice number
    PdfTextElement element =
        PdfTextElement(text: 'ADMISSION FORM DETAILS', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page1, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;
    String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    Offset textPosition = Offset(
        page1.graphics.clientSize.width - textSize.width - 10,
        result.bounds.top);

//Draws the date by using drawString method
    page1.graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(page1.graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: 'Name: ${_name.text}',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 25,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

    element = PdfTextElement(
        text: 'Selected Course: ${selectedCourse}',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          18,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: 'Selected Discipline: ${selecteddiscipline} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: 'Father\'s name: ${_fname.text} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: 'Mother\'s name: ${_mname.text} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: 'Date of Birth: ${_dob.text} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: 'Aadhar: ${_aadharno.text} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Cateogery: " + Cateogery.value}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Phone: " + _phoneno.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Email: " + _email.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Vill: " + _vill.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Post office: " + _poffice.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"District: " + _district.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"State: " + _state.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Picode: " + _pincode.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Last Exam Qualified: " + _lastexamQual.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Percent: " + _percent.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Exam Roll No: " + _examRollNo.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "${"Exam Roll Code : " + _boardRollCode.text}",
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));

    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    page1.graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 3),
        Offset(page1.graphics.clientSize.width, result.bounds.bottom + 3));

    page1.graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.top + 3),
        Offset(page1.graphics.clientSize.width, result.bounds.top + 3));

    List<int> bytes = document.save() as List<int>;
    loadAndLaunchPdf(bytes, "AisectApply.pdf");
// // Save the document.

// // Dispose the document.
    document.dispose();

//     //Save & Launching pdf
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  int value = 0;
  continued() {
    print("i'm checking");
    if (_formKeys[_currentStep].currentState!.validate()) {
      _currentStep < 3
          ? setState(() => _currentStep += 1)
          : setState(() => value += 1);
      // if (_currentStep < 4) {
      //   print(_currentStep);
      // }
      print(_currentStep);
      if (value == 1) {
        print("clicked");
        addexamformApplication();

        _createPdf();
        Semesterforbd.value = "semester";
        coursefordb.value = "course";
        disciplinefordb.value = "Discipline";
        clearTextInput();
        showDialog(
          context: context,
          builder: (_) => AdvanceDialog(
            s: "Your Exam Form is submitted sucessfully",
            title: "Sucess",
          ),
        );
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
    } else {
      print("error");
      Fluttertoast.showToast(
          msg: "All Fields are required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
