import 'dart:async';
import 'dart:io';

import 'package:aisect_custom/GetController/authController.dart';
import 'package:aisect_custom/Home/HomePage%20copy.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:sms_autofill/sms_autofill.dart';


// import 'Home.dart';

enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class LoginForAdmission extends StatefulWidget {
  const LoginForAdmission({Key? key}) : super(key: key);

  @override
  _LoginForAdmissionState createState() => _LoginForAdmissionState();
}

class _LoginForAdmissionState extends State<LoginForAdmission> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController profilename = TextEditingController();
  TextEditingController profilphone = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profilCourse = TextEditingController();
  TextEditingController profileDisci = TextEditingController();
  LoginScreen currentStateA = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  var otp;

  var _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

// bool _isLoadingForverify = false;
  RxBool _isLoading = false.obs;
  String uid = "no user";
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionRef =
      _firestore.collection("students");
  //! creating user
  Future createUser() async {
    try {
      await _userCollectionRef.doc(uid).set({
        'full name': profilename.text,
        'Phone No': profilphone.text,
        'role': 'student'
      });
    } catch (e) {
      return showToast(e.toString());
    }
  }

  showToast(String error) {
    Fluttertoast.showToast(msg: "$error");
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
    phoneController.dispose();
    otpController1.dispose();
    otpController.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    otpController5.dispose();
    otpController6.dispose();
    nameController.dispose();
    passController.dispose();
  }

  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = await FirebaseAuth.instance.currentUser;
    // await firebaseUser!.reload();

    if (firebaseUser != null) {
      final user = firebaseUser.uid;
      // setState(() {
      //   uid = user.toString();
      // });

      print(user.toString());
    }

    // await FirebaseAuth.instance.signOut();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  showMobilePhoneWidget(context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/illustration-2.png',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Admission Registration',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent.shade200,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add your phone number. we'll send you a verification code so we know you're real",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (!phoneRegex.hasMatch(val!)) {
                              return "invalid";
                            }
                            return null;
                          },
                          maxLength: 10,
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26,
                          ),
                          decoration: InputDecoration(
                            labelText: "Mobile",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            prefix: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '(+91)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            suffixIcon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate() &&
                                  Platform.isAndroid) {
                                _isLoading.value = true;

                                otpSendMethod();
                                await Future.delayed(
                                    const Duration(milliseconds: 40));
                                _isLoading.value = false;
                              } else if (kIsWeb) {
                                Get.to(() =>  HomePageNav());
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Fool! Give me Food :(");
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.purple),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: _isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Send',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future otpSendMethod() async {
    // var phone = phoneController.text;
    // bool phoneValid = phoneRegex.hasMatch(phone);
    // if (phoneController.text.isEmpty ||
    //     phoneController.text.length < 10 ||
    //     phoneValid == false) {
    //   // print("null phone no");
    //   Fluttertoast.showToast(
    //       msg: "Fool! Give me Food :(",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // } else {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) async {
          createUser();
          Fluttertoast.showToast(msg: "User Created");
        },
        verificationFailed: (FirebaseAuthException e) async {
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(msg: "Invalid Phone Number");
          }
        },
        codeSent: (verificationID, resendingToken) async {
          setState(() {
            currentStateA = LoginScreen.SHOW_OTP_FORM_WIDGET;
            this.verificationID = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (verificationID) async {});
    // }
  }

  bool _isLoadingForverify = false;
  showOtpFormWidget(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 171, 165, 193),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(top: Constant.height / 15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Constant.height / 40,
              ),
              Container(
                width: Constant.width,
                height: Constant.height / 4.3,
                decoration: const BoxDecoration(
                  // color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/illustration-3.png',
                ),
              ),
              SizedBox(
                height: Constant.height / 30,
              ),
              Text(
                'VERIFICATION',
                style: TextStyle(
                  fontSize: Constant.height / 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Constant.height / 30,
              ),
              Text(
                "Enter your OTP ",
                style: TextStyle(
                  fontSize: Constant.height / 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Constant.height / 25,
              ),
              Container(
                // padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 171, 165, 193),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Constant.width / 22),
                      child: Row(
                        children: [
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController1),
                          SizedBox(width: Constant.width / 52),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController2),
                          SizedBox(width: Constant.width / 52),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController3),
                          SizedBox(width: Constant.width / 52),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController4),
                          SizedBox(width: Constant.width / 52),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController5),
                          SizedBox(width: Constant.width / 52),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: otpController6),
                        ],
                      ),
                    )
                    // PinFieldAutoFill(
                    //   focusNode: focusNode,
                    //   cursor: Cursor(color: Colors.deepOrange),
                    //   controller: otpController,
                    //   codeLength: 6,
                    //   decoration: BoxLooseDecoration(
                    //     textStyle: TextStyle(color: Colors.white),
                    //     // bgColorBuilder: FixedColorBuilder(Colors.black54),
                    //     strokeColorBuilder: FixedColorBuilder(Colors.black),
                    //     gapSpace: 6,
                    //   ),
                    //   onCodeChanged: (value) {
                    //     print(value);
                    //     if (value!.length == 1 && value.length == 6) {
                    //       FocusScope.of(context).nextFocus();
                    //     }
                    //     if (value.length == 0 && value.length == 1) {
                    //       FocusScope.of(context).previousFocus();
                    //     }
                    //     if (value.length == 6) {
                    //       setState(() {
                    //         _isLoadingForverify = true;
                    //       });
                    //       AuthCredential phoneAuthCredential =
                    //           PhoneAuthProvider.credential(
                    //               verificationId: verificationID,
                    //               smsCode: otpController.text);
                    //       signInWithPhoneAuthCred(phoneAuthCredential,
                    //           nameController.text, phoneController.text);
                    //       Future.delayed(Duration(milliseconds: 200));
                    //       setState(() {
                    //         _isLoadingForverify = false;
                    //       });
                    //     }
                    //   },
                    // ),
                    ,
                    SizedBox(
                      height: Constant.height / 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.size.width / 3,
                            height: Constant.height / 18,
                            child: ElevatedButton(
                              onPressed: () async {
                                // _isLoadingForResend.value = true;
                                FocusScope.of(context).unfocus();
                                _timer?.cancel();
                                await EasyLoading.show(status: 'resending..');
                                otpSendMethod();
                                await Future.delayed(
                                    const Duration(seconds: 3));
                                EasyLoading.dismiss();

                                Fluttertoast.showToast(
                                    msg: "OTP resended sucessfully");
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Resend otp',
                                  style:
                                      TextStyle(fontSize: Constant.height / 35),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.size.width / 3,
                            height: Constant.height / 18,
                            child: ElevatedButton(
                              onPressed: () async {
                                otp = otpController1.text +
                                    otpController2.text +
                                    otpController3.text +
                                    otpController4.text +
                                    otpController5.text +
                                    otpController6.text;

                                // _isLoadingForverify.value = true;
                                FocusScope.of(context).unfocus();
                                _timer?.cancel();
                                await EasyLoading.show(status: 'matching...');

                                AuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationID,
                                        smsCode: otp);
                                signInWithPhoneAuthCredForAdmission(
                                  phoneAuthCredential,
                                );
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                EasyLoading.dismiss();
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'confirm',
                                  style:
                                      TextStyle(fontSize: Constant.height / 35),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              // s
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff7f6fb),
        body: Consumer<ConnectivityProvider>(
            builder: (consumerContext, model, child) {
          return model.isOnline
              ? currentStateA == LoginScreen.SHOW_MOBILE_ENTER_WIDGET
                  ? showMobilePhoneWidget(context)
                  : showOtpFormWidget(context)
              : NoInternet();
          ;
          return Container(
            child: Center(
              child: SpinKitDoubleBounce(),
            ),
          );
        }));
  }

  // // Get the proportionate height as per screen size

  Widget _textFieldOTP({required bool first, last, controller}) {
    assert(controller != null);
    return Container(
      height: 85,
      width: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            // ignore: prefer_is_empty
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
