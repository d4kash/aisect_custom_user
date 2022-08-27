import 'dart:async';
import 'dart:ui';

import 'package:aisect_custom/GetController/authController.dart';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/utils/image_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:carbon_icons/carbon_icons.dart';

import '../widget/platform.dart';
import 'phoneAuthFile/trialPhoneAuth.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// import 'Home.dart';

// ignore: constant_identifier_names
enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class LoginA extends StatefulWidget {
  const LoginA({Key? key}) : super(key: key);

  @override
  _LoginAState createState() => _LoginAState();
}

class _LoginAState extends State<LoginA> {
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  // late double screenHeight1;

  // late double screenWidth1;

  var otp;

  var _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  final RxBool _isLoadingForverify = false.obs;
  final RxBool _isLoadingForResend = false.obs;
  final RxBool _isLoading = false.obs;
  // String uid = "no user";
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionRef =
      _firestore.collection("Raw_students_info");
  //! creating user
  Future createUser() async {
    try {
      await _userCollectionRef.doc(constuid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'isHomeVisited': false,
        'role': 'student'
      });
    } catch (e) {
      return showToast(e.toString());
    }
  }

  showToast(String error) {
    Fluttertoast.showToast(msg: error);
  }

  @override
  void dispose() {
    super.dispose();
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

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Raw_students_info").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.id);
    }
  }

  var a;

  showMobilePhoneWidget(context) {
    return SingleChildScrollView(
      reverse: true,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      // onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
                  child: ChasedNetwork(phoneAuth2)),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Constant.height / 25,
              ),
              Text(
                "Add your phone number. we'll send you a verification code so we know you're real",
                style: TextStyle(
                  fontSize: Constant.height / 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Constant.height / 25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  // height: double.infinity,
                  // width: double.infinity,
                  color: Colors.black,
                  child: Stack(children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Constant.height / 5,
                            width: 200,
                            margin: const EdgeInsets.only(left: 200),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade700,
                                    Colors.orange.shade500
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          Container(
                            height: Constant.height / 12,
                            width: 200,
                            margin: const EdgeInsets.only(right: 270),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade700,
                                    Colors.orange.shade500
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(100)),
                          )
                        ],
                      ),
                    ),
                    Stack(children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 15,
                          sigmaY: 15,
                        ),
                        child: SizedBox(
                          height: Constant.height / 2.5,
                          width: Constant.width,
                        ),
                      ),
                      Container(
                        height: Constant.height / 2.5,
                        width: Constant.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 208, 112, 249)
                                    .withOpacity(0.30),
                              )
                            ],
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.0),
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 143, 172, 168)
                                    .withOpacity(0.5),
                                const Color.fromARGB(255, 114, 168, 167)
                                    .withOpacity(0.2)
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _key,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "required";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z]+|\s'))
                                  ],
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 228, 226, 222),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    errorStyle:
                                        const TextStyle(color: Colors.orange),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefix: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        'Name : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white54,
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
                                SizedBox(
                                  height: Constant.height / 25,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                    color: Color.fromARGB(255, 228, 226, 222),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Mobile",
                                    errorStyle:
                                        const TextStyle(color: Colors.orange),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black45),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefix: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        '(+91)',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white54,
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
                                SizedBox(
                                  height: Constant.height / 35,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Let's Crack this!",
                                        style: TextStyle(
                                            fontSize: Constant.height / 50,
                                            color: const Color.fromARGB(
                                                255, 74, 20, 112),
                                            fontWeight: FontWeight.w500)),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        width: Constant.width / 7.5,
                                        height: Constant.height / 18,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.orange),
                                        child: IconButton(
                                          // color: const Color.fromARGB(2, 207, 183, 238),
                                          icon: Icon(
                                            CarbonIcons.arrow_right,
                                            size: Constant.height / 30,
                                          ),
                                          onPressed: () async {
                                            if (_key.currentState!.validate()) {
                                              _isLoading.value = true;
                                              FocusScope.of(context).unfocus();
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                              _timer?.cancel();
                                              await EasyLoading.show(
                                                  status: 'fetching...');
                                              // Get.to(() =>
                                                  // VerifyPhoneNumberScreen(
                                                  //     phoneNumber:
                                                  //         phoneController.text,
                                                  //     name: nameController.text,
                                                  //     phone: phoneController
                                                  //         .text));

                                              if (PlatformInfo().isWeb()) {
                                                print(PlatformInfo().isWeb());
                                              } else {
                                                // otpSendMethod();
                                              }
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500));

                                              EasyLoading.dismiss();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Fool! Give me Food :(");
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future otpSendForWeb() async {
    ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
      "+91${phoneController.text}",
    );
    UserCredential userCredential = await confirmationResult.confirm(otp);
    RecaptchaVerifier(
      container: 'recaptcha',
      size: RecaptchaVerifierSize.compact,
      theme: RecaptchaVerifierTheme.dark,
      onSuccess: () => print('reCAPTCHA Completed!'),
      onError: (FirebaseAuthException error) => print(error),
      onExpired: () => print('reCAPTCHA Expired!'),
    );
  }

  Future otpSendMethod() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) async {
          await createUser();
          Fluttertoast.showToast(msg: "User Created");
        },
        verificationFailed: (FirebaseAuthException e) async {
          _isLoading.value = false;

          if (e.code == 'invalid-phone-number') {
            Constant.showSnackBar(context, "Invalid phone number");
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

  FocusNode focusNode = FocusNode();
  // bool _isLoadingForverify = false;
  showOtpFormWidget(context) {
    return Scaffold(
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
                child: ChasedNetwork(phoneauth1),
                // child: Image.asset(
                //   'assets/images/illustration-3.png',
                // ),
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
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: [
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController1),
                        // SizedBox(width: Constant.width / 54),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController2),
                        // SizedBox(width: Constant.width / 58),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController3),
                        // SizedBox(width: Constant.width / 58),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController4),
                        // SizedBox(width: Constant.width / 58),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController5),
                        // SizedBox(width: Constant.width / 58),
                        _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpController6),
                      ],
                    ),
                    SizedBox(
                      height: Constant.height / 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        spacing: Constant.width / 5,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _isLoadingForResend.value == false
                              ? SizedBox(
                                  width: Get.size.width / 3,
                                  height: Constant.height / 15,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      // _isLoadingForResend.value = true;
                                      FocusScope.of(context).unfocus();
                                      _isLoadingForResend.value = true;
                                      _timer?.cancel();
                                      await EasyLoading.show(
                                          status: 'resending..');

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
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: FittedBox(
                                        child: Text(
                                          'Resend otp',
                                          style: TextStyle(
                                              fontSize: Constant.height / 35),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: Constant.height / 15,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                          _isLoadingForverify.value == false
                              ? SizedBox(
                                  width: Get.size.width / 3,
                                  height: Constant.height / 15,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      otp = otpController1.text +
                                          otpController2.text +
                                          otpController3.text +
                                          otpController4.text +
                                          otpController5.text +
                                          otpController6.text;

                                      //
                                      FocusScope.of(context).unfocus();
                                      _isLoadingForverify.value = true;
                                      _timer?.cancel();
                                      await EasyLoading.show(
                                          status: 'matching...');

                                      AuthCredential phoneAuthCredential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationID,
                                              smsCode: otp);
                                      signInWithPhoneAuthCred(
                                          phoneAuthCredential,
                                          nameController.text,
                                          phoneController.text);
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      _isLoadingForverify.value = false;
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
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: FittedBox(
                                        child: Text(
                                          'confirm',
                                          style: TextStyle(
                                              fontSize: Constant.height / 35),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: Constant.height / 15,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
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
        }));
  }

  // // Get the proportionate height as per screen size

  Widget _textFieldOTP({required bool first, last, controller}) {
    assert(controller != null);
    return SizedBox(
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
            if (value.isEmpty && first == false) {
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
