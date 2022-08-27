//! \\ Submitting Application to fbdb

// import 'package:aisect_custom/inside_Admis/Courses_Fee.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/login/services/pdf.dart';
import 'package:aisect_custom/model/statusModal.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/CourseSelection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../GetController/theme_controller.dart';
import '../model/AdmissionModal.dart';
import '../widget/containerWidget.dart';
import '../firebase_helper/FirebaseConstants.dart';
import '../widget/appBar.dart';
import '../widget/customDialog.dart';

class ApplyForAdmission extends StatefulWidget {
  const ApplyForAdmission({Key? key}) : super(key: key);

  @override
  _ApplyForAdmissionState createState() => _ApplyForAdmissionState();
}

class _ApplyForAdmissionState extends State<ApplyForAdmission>
    with TickerProviderStateMixin {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    // GlobalKey<FormState>(),
  ];

  // final _formKeycourse = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _fname;
  late TextEditingController _mname;
  late TextEditingController _email;
  late TextEditingController _aadharno;
  late TextEditingController _phoneno;
  late TextEditingController _vill;
  late TextEditingController _poffice;
  late TextEditingController _district;
  late TextEditingController _state;
  late TextEditingController _pincode;
  late TextEditingController _lastexamQual;
  late TextEditingController _percent;
  late TextEditingController _board;
  late TextEditingController _boardRoll1;
  late TextEditingController _boardRollCode;
  late TextEditingController _dob;
  late TextEditingController _examRollNo;
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  // var name1 = _name.text;
  bool isStrechedDropDown = false;
  bool isStrechedDropDownForDiscipline = false;

  String title = 'Select Course';
  String title1 = 'Select Discipline';
  ScrollController controller = ScrollController();
  ScrollController controller1 = ScrollController();

  List<dynamic> selected = [];
  DateTime currentDate = DateTime.now();
  final dateFormat = DateFormat('dd-MM-yyyy');
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? _user;

  String? uid;

  FormTextCont textBox = FormTextCont(); //for textField
  var getcontroller = Get.put(RadioController());
  final RxInt _currentStep = 0.obs;

  String? token;
  Future initializeUser() async {
    try {
      var _auth = FirebaseAuth.instance;
      if (_auth.currentUser != null) {
        uid = constuid;
        _name = TextEditingController();
        _fname = TextEditingController();
        _mname = TextEditingController();
        _email = TextEditingController();
        _aadharno = TextEditingController();
        _phoneno = TextEditingController();
        _vill = TextEditingController();
        _poffice = TextEditingController();
        _district = TextEditingController();
        _state = TextEditingController();
        _pincode = TextEditingController();
        _lastexamQual = TextEditingController();
        _percent = TextEditingController();
        _board = TextEditingController();
        _boardRoll1 = TextEditingController();
        _boardRollCode = TextEditingController();
        _dob = TextEditingController();
        _examRollNo = TextEditingController();
      } else {
        print("not logged in");
        _name = TextEditingController();
        _fname = TextEditingController();
        _mname = TextEditingController();
        _email = TextEditingController();
        _aadharno = TextEditingController();
        _phoneno = TextEditingController();
        _vill = TextEditingController();
        _poffice = TextEditingController();
        _district = TextEditingController();
        _state = TextEditingController();
        _pincode = TextEditingController();
        _lastexamQual = TextEditingController();
        _percent = TextEditingController();
        _board = TextEditingController();
        _boardRoll1 = TextEditingController();
        _boardRollCode = TextEditingController();
        _dob = TextEditingController();
        _examRollNo = TextEditingController();
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    initializeUser();
  }

  // CollectionReference firestore = FirebaseFirestore.instance.collection("Admission_Application");
  final CollectionReference admissionApplication =
      FirebaseFirestore.instance.collection("New_Admission_Application");
  final CollectionReference trackadmissionApplication =
      FirebaseFirestore.instance.collection("track_Admission_Application");

  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }

  Future<void> trackApp(String token) {
    var trackUpload = StatusModal(
        token: token,
        status: 1,
        assignedRoll: '',
        acceptTime: '',
        acceptDate: '',
        verifyTime: '',
        verifyDate: '',
        allotedDate: '');
    return trackadmissionApplication.doc(constuid).set(trackUpload.toMap());
  }

  Future<void> addAdmissionApplication() {
    // Call the user's CollectionReference to add a new user
    var uploadData = AdmissionModal(
        full_name: _name.text,
        D_O_B: _dob.text,
        father_name: _fname.text,
        mother_name: _mname.text,
        Email: _email.text,
        Phone_No: _phoneno.text,
        Aadhar_No: _aadharno.text,
        Course: getcontroller.facultySubject.string,
        Discipline: getcontroller.selected.string,
        Vill: _vill.text,
        PO: _poffice.text,
        District: _district.text,
        State: _state.text,
        Pincode: _pincode.text,
        Exam_Roll_NO: _examRollNo.text,
        Last_Exam_Qualified: _lastexamQual.text,
        Percent: _percent.text,
        board: _board.text,
        status: 1,
        token: token,
        batch: getcontroller.selectedbatch.string,
        Date: getCurrentDate());
    return admissionApplication
        .doc(
            "${_name.text} : applied for ${getcontroller.facultySubject.string}")
        .set(uploadData.toMap())
        .catchError((error) => Fluttertoast.showToast(msg: "$error"));
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
    _examRollNo.dispose();
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

  //  _currentStep.value = 0;
  StepperType stepperType = StepperType.vertical;

  ImagePicker image = ImagePicker();
  File? file;
  Future getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // await uploadImageToFirebase();
    EasyLoading.showSuccess('Success!');
  }

  @override
  Widget build(BuildContext context) {
    // print(selectedCourse);
    return Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(title: "Apply"),
        body: Consumer<ConnectivityProvider>(
            builder: (consumerContext, model, child) {
          if (model.isOnline) {
            return model.isOnline
                ? FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString("assets/files/courses.json"),
                    builder: (context, snapshot) {
                      var myDataFromJson =
                          json.decode(snapshot.data.toString());
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<dynamic> jsondiplomaCourse =
                            myDataFromJson["Diploma"];
                        List<dynamic> jsonSemester =
                            myDataFromJson["admissionSem"];

                        List<dynamic> jsonug = myDataFromJson["UG"];
                        // print(jsonug);
                        List<dynamic> jsonpg = myDataFromJson["PG"];
                        List<dynamic> jsoncateogery =
                            myDataFromJson["cateogery"];
                        List<dynamic> jsonbatch =
                            myDataFromJson["admissionBatch"];
                        // print(jsonpg);
                        List<dynamic> jsoncourse = myDataFromJson["course"];
                        return newMethod(context, jsonSemester, jsoncourse,
                            jsondiplomaCourse, jsonug, jsonpg, jsonbatch);
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CircularProgressIndicator(),
                              // showLoaderDialog(context),

                              Constant.circle(),
                              SizedBox(height: Constant.height / 40),
                              const Text("Loading..")
                            ],
                          ),
                        );
                      }
                    },
                  )
                : NoInternet();
          }

          return Center(
            child: Constant.circle(),
          );
        }));
    //);
  }

  Widget newMethod(
      BuildContext context,
      List<dynamic> jsonSemester,
      List<dynamic> jsoncourse,
      List<dynamic> jsondiplomaCourse,
      List<dynamic> jsonug,
      List<dynamic> jsonpg,
      jsonbatch) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Obx(
              () => Stepper(
                type: StepperType.vertical,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                currentStep: _currentStep.toInt(),
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  final isLastStep = _currentStep.toInt() == 4;
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
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        children: <Widget>[
                          textBox.formText(
                              _name,
                              const Icon(Icons.person, color: Colors.black),
                              "Name",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _fname,
                              const Icon(Icons.person, color: Colors.black),
                              "Father's Name",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _mname,
                              const Icon(Icons.person, color: Colors.black),
                              "Mother's Name",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
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
                                child: textBox.formText(
                                    _dob,
                                    const Icon(Icons.person,
                                        color: Colors.black),
                                    "D.O.B",
                                    [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9./-]+|\s'))
                                    ],
                                    RequiredValidator(errorText: "*required"),
                                    10,
                                    TextInputType.name,
                                    Colors.amber[300]),
                                // child: VxTextField(
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep.toInt() >= 0,
                    state: _currentStep.toInt() >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Address'),
                    content: Form(
                      key: _formKeys[1],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // child: ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: map.length,
                      //     itemBuilder: (BuildContext context, index) {
                      //       return textBox.formText(
                      //         map[index]['controller'],
                      //         map[index]['icon'],
                      //         map[index]['label'],
                      //         map[index]['filter'],
                      //         map[index]['validator'],
                      //         map[index]['max'],
                      //         map[index]['textType'],
                      //         map[index]['color'],
                      //       );
                      //     }),
                      child: Column(
                        children: <Widget>[
                          textBox.formText(
                              _vill,
                              const Icon(Icons.person, color: Colors.black),
                              "building,street,",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _poffice,
                              const Icon(Icons.person, color: Colors.black),
                              "Post office",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _district,
                              const Icon(Icons.person, color: Colors.black),
                              "District",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _state,
                              const Icon(Icons.person, color: Colors.black),
                              "State",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              25,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _pincode,
                              const Icon(Icons.person, color: Colors.black),
                              "pincode",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              MultiValidator([
                                RequiredValidator(errorText: "@required"),
                                LengthRangeValidator(
                                    errorText: "not valid", max: 6, min: 6),
                              ]),
                              6,
                              TextInputType.number,
                              Colors.amber[300]),
                        ],
                      ),
                    ),
                    isActive: _currentStep.toInt() >= 0,
                    state: _currentStep.toInt() >= 1
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
                          textBox.formText(
                              _lastexamQual,
                              const Icon(Icons.person, color: Colors.black),
                              "last exam qualified",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _examRollNo,
                              const Icon(Icons.person, color: Colors.black),
                              "Last exam roll number",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9]'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                          textBox.formText(
                              _percent,
                              const Icon(Icons.person, color: Colors.black),
                              "CGPA,SGPA,percentage gained",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              const TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              Colors.amber[300]),
                          textBox.formText(
                              _board,
                              const Icon(Icons.person, color: Colors.black),
                              "Board",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]+|\s'))
                              ],
                              RequiredValidator(errorText: "*required"),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                        ],
                      ),
                    ),
                    isActive: _currentStep.toInt() >= 0,
                    state: _currentStep.toInt() >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Contact Details'),
                    content: Form(
                      key: _formKeys[3],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          textBox.formText(
                              _phoneno,
                              const Icon(Icons.person, color: Colors.black),
                              "phone ", [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ], (val) {
                            if (!phoneRegex.hasMatch(val!)) {
                              return "Not Valid";
                            }
                            return null;
                          }, 10, TextInputType.number, Colors.amber[300]),
                          textBox.formText(
                              _aadharno,
                              const Icon(Icons.person, color: Colors.black),
                              "aadhar no", [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ], (val) {
                            if (!aadharRegex.hasMatch(val!)) {
                              return "Not Valid aadhar";
                            }
                            return null;
                          }, 12, TextInputType.number, Colors.amber[300]),
                          textBox.formText(
                              _email,
                              const Icon(Icons.person, color: Colors.black),
                              "email id",
                              [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z.@]'))
                              ],
                              MultiValidator([
                                RequiredValidator(errorText: "@required"),
                                EmailValidator(errorText: "not valid"),
                              ]),
                              30,
                              TextInputType.name,
                              Colors.amber[300]),
                        ],
                      ),
                    ),
                    isActive: _currentStep.toInt() >= 0,
                    state: _currentStep.toInt() >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Select Course'),
                    content: Form(
                      key: _formKeys[4],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(children: [
                        CourseDropDown(
                          jsonbatch: jsonbatch,
                          jsoncourse: jsoncourse,
                          jsondiplomaCourse: jsondiplomaCourse,
                          jsonpg: jsonpg,
                          jsonSemester: jsonSemester,
                          jsonug: jsonug,
                        ),
                      ]),
                    ),
                    isActive: _currentStep.toInt() >= 0,
                    state: _currentStep.toInt() >= 4
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //
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

    // PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

    // element = PdfTextElement(
    //     text: 'Selected Course: ${selectedCourse}',
    //     font: PdfStandardFont(
    //       PdfFontFamily.timesRoman,
    //       18,
    //     ));
    // element.brush = PdfBrushes.black;
    // result = element.draw(
    //     page: page1,
    //     bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(
        text: 'Selected Discipline: ${getcontroller.selected.string} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    element = PdfTextElement(
        text: 'Selected Faculty: ${getcontroller.facultySubject.string} ',
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
        text: "Phone: " + _phoneno.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Email: " + _email.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Vill: " + _vill.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Post office: " + _poffice.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "District: " + _district.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "State: " + _state.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Picode: " + _pincode.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Last Exam Qualified: " + _lastexamQual.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Percent: " + _percent.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: "Last Exam Roll No: " + _examRollNo.text,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));
    // element.brush = PdfBrushes.black;
    // result = element.draw(
    //     page: page1,
    //     bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    // element = PdfTextElement(
    //     text: "${"Exam Roll Code : " + _boardRollCode.text}",
    //     font: PdfStandardFont(
    //       PdfFontFamily.timesRoman,
    //       20,
    //     ));

    // element.brush = PdfBrushes.black;
    // result = element.draw(
    //     page: page1,
    //     bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
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
    _currentStep.value = step;
  }

  RxInt value = 0.obs;
  continued() {
    try {
      print("i'm checking");
      if (_formKeys[_currentStep.toInt()].currentState!.validate()) {
        _currentStep.toInt() < 4
            ? _currentStep.value = _currentStep.toInt() + 1
            : value.value = value.toInt() + 1;
        print(_currentStep.toString());
        FocusScope.of(context).unfocus();
        if (value.toInt() == 1 &&
            getcontroller.facultySubject.string != "" &&
            getcontroller.selected.string != "") {
          token = generateRandomString();
          print("clicked");
          print(getcontroller.selected.string);
          print(getcontroller.facultySubject.string);
          print(value.toInt());
          addAdmissionApplication();
          trackApp(token!);
          _createPdf();
          clearTextInput();
          showDialog(
            context: context,
            builder: (_) => AdvanceDialog(
              s: "Your Application is submitted sucessfully\n and your token no is \"$token\"",
              title: "Sucess",
            ),
          );
        } else {
          Constant.showSnackBar(context, "Please fill all required details");
          print("error in checking");
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
    } catch (e) {
      print("error: $e");
    }
    // _currentStep < 4 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    FocusScope.of(context).unfocus();
    _currentStep.toInt() > 0
        ? _currentStep.value = _currentStep.toInt() - 1
        : null;
    value.value = 0;
  }

//generation of tokens
  String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(6, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
