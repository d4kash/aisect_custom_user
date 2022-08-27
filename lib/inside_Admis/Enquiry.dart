import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/login/services/pdf.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/customDialog.dart';
import 'package:aisect_custom/Home/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/containerWidget.dart';
import '../firebase_helper/FirebaseConstants.dart';

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({Key? key}) : super(key: key);

  @override
  _EnquiryFormState createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _aadharno = TextEditingController();
  final _phoneno = TextEditingController();
  final _question = TextEditingController();
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "no User";
  User? _user;

  Future initializeUser() async {
    _user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userEnq =
      FirebaseFirestore.instance.collection("userEnq");

  Future<void> addUserEnq() {
    // Call the user's CollectionReference to add a new user
    return userEnq.doc(constuid).set({
      'full_name': _name.text, // John Doe
      'aadhar_no': _aadharno.text, // Stokes and Sons
      'phone_no': _phoneno.text,
      'questions': _question.text,
    }).catchError((error) => Fluttertoast.showToast(msg: "$error"));
  }

  clearTextInput() {
    _name.clear();
    _aadharno.clear();
    _phoneno.clear();
    _question.clear();
  }

  @override
  void dispose() {
    _name.dispose();
    _aadharno.dispose();
    _phoneno.dispose();
    _question.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double height1 = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            // backgroundColor: const Color(0xffe7f0fd),
            appBar: AppBarScreen(title: "Enquiry Form"),
            body: Consumer<ConnectivityProvider>(
                builder: (consumerContext, model, child) {
              if (model.isOnline) {
                return model.isOnline ? enq(context) : NoInternet();
              }

              return Center(
                child: Constant.circle(),
              );
            })));
  }

  Widget enq(BuildContext context) {
    widget cont = widget();
    FormTextCont cons = FormTextCont();
    return SingleChildScrollView(
      reverse: true,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Constant.height / 38),
            child: Text("Feel Free to ask !",
                style: GoogleFonts.montserrat(
                    color: AppColors.enqFontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26)),
          ),
          SizedBox(height: Constant.height / 20),
          const Text("Request a call from our Experts"),
          SizedBox(height: Constant.height / 10),
          Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                cons.formText(
                    _name,
                    const Icon(Icons.person, color: Colors.black),
                    "Name",
                    [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+|\s'))
                    ],
                    RequiredValidator(errorText: "Required"),
                    20,
                    TextInputType.name,
                    Colors.amber[300]),
                cons.formText(
                    _phoneno,
                    const Icon(Icons.person, color: Colors.black),
                    "Phone Number",
                    [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    RequiredValidator(errorText: "starts with 6"),
                    10,
                    TextInputType.number,
                    Colors.amber[300]),
                cons.formText(
                    _question,
                    const Icon(Icons.person, color: Colors.black),
                    "Topic For Discussion",
                    [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]+|\s'))
                    ],
                    RequiredValidator(errorText: "Required"),
                    25,
                    TextInputType.name,
                    Colors.amber[300]),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Material(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 150,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          addUserEnq();
                          _createPdf();
                          clearTextInput();
                          print("check success");
                          showDialog(
                            context: context,
                            builder: (_) => AdvanceDialog(
                                title: "Sucess",
                                s: " Your Enquiry is submitted"),
                          );
                        } else {
                          print("check fails");
                          Constant.showSnackBar(
                              context, "* All Fields are required !");
                          // Fluttertoast.showToast(
                          //     msg: "All Fields are required",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);
                        }
                        print("Button Tapped");
                      },
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );

    //BouncingButton(),
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
        PdfTextElement(text: 'ENQUIRY FORM DETAILS', font: subHeadingFont);
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

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

    result = element.draw(
        page: page1,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
    element = PdfTextElement(
        text: 'Aadhar: ${_aadharno.text} ',
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          20,
        ));

    ;
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
        text: "Question : " + _question.text,
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

    // page1.graphics.drawLine(
    //     PdfPen(PdfColor(126, 151, 173), width: 0.7),
    //     Offset(0, result.bounds.top + 3),
    //     Offset(page1.graphics.clientSize.width, result.bounds.top + 3));

    List<int> bytes = document.save() as List<int>;
    loadAndLaunchPdf(bytes, "EnquiryRecieving.pdf");
// // Save the document.

// // Dispose the document.
    document.dispose();

//     //Save & Launching pdf
  }

  multiCheck(String text) {
    int len = text.length;
    if (len < 12) {
      return "Enter 12 no";
    } else
      return "Good to go";
  }
}

String validateMob(String value) {
  if (!(value.length < 10) && value.isEmpty) {
    return "Correct It";
  }
  return "";
}
