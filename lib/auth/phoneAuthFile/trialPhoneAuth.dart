// import 'dart:async';
// import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
// import 'package:aisect_custom/auth/phoneAuthFile/custom_loader.dart';
// import 'package:aisect_custom/auth/phoneAuthFile/utils/helpers.dart';
// import 'package:aisect_custom/services/LocalData.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// import '../../Home/CompleteProfile.dart';
// import '../../afterLogin/creatingUser.dart';
// import '../../firebase_helper/FirebaseConstants.dart';
// import 'pin_input_field.dart';

// // ignore: must_be_immutable
// class VerifyPhoneNumberScreen extends StatefulWidget
//     with WidgetsBindingObserver {
//   static const id = 'VerifyPhoneNumberScreen';

//   final String phoneNumber;
//   final String name, phone;

//   VerifyPhoneNumberScreen({
//     Key? key,
//     required this.phoneNumber,
//     required this.name,
//     required this.phone,
//   }) : super(key: key);

//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static final CollectionReference _userCollectionRef =
//       _firestore.collection("Raw_students_info");

//   @override
//   State<VerifyPhoneNumberScreen> createState() =>
//       _VerifyPhoneNumberScreenState();
// }

// class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
//   String? _enteredOTP;

//   void _showSnackBar(BuildContext context, String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(text)),
//     );
//   }

//   bool isKeyboardVisible = false;

//   late final ScrollController scrollController;

//   @override
//   void initState() {
//     scrollController = ScrollController();
//     // WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // WidgetsBinding.instance.removeObserver(_VerifyPhoneNumberScreen);
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeMetrics() {
//     final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
//     isKeyboardVisible = bottomViewInsets > 0;
//   }

//   // scroll to bottom of screen, when pin input field is in focus.
//   Future<void> _scrollToBottomOnKeyboardOpen() async {
//     while (!isKeyboardVisible) {
//       await Future.delayed(const Duration(milliseconds: 50));
//     }

//     await Future.delayed(const Duration(milliseconds: 250));

//     await scrollController.animateTo(
//       scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 250),
//       curve: Curves.easeIn,
//     );
//   }

//   //! creating user
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FirebasePhoneAuthHandler(
//         phoneNumber: "+91${widget.phoneNumber}",
//         onLoginSuccess: (userCredential, autoVerified) async {
//           log(
//             VerifyPhoneNumberScreen.id,
//             msg: autoVerified
//                 ? 'OTP was fetched automatically!'
//                 : 'OTP was verified manually!',
//           );

//           showSnackBar('Phone number verified successfully!');

//           log(
//             VerifyPhoneNumberScreen.id,
//             msg: 'Login Success UID: ${userCredential.user?.uid}',
//           );

//           Get.off(() => const CreatingUser());
//           //         // Constant.signInWithPhoneAuthCred(name, phone);
//           debugPrint(
//             autoVerified
//                 ? "OTP was fetched automatically"
//                 : "OTP was verified manually",
//           );

//           debugPrint("Login Success UID: ${userCredential.user?.uid}");
//         },
//         onLoginFailed: (authException) {
//           showSnackBar('Something went wrong!');
//           log(VerifyPhoneNumberScreen.id, error: authException.message);
//           // handle error further if needed
//         },
//         builder: (context, controller) {
//           return Scaffold(
//             appBar: AppBar(
//               leadingWidth: 0,
//               leading: const SizedBox.shrink(),
//               title: const Text('Verify Phone Number'),
//               actions: [
//                 if (controller.codeSent)
//                   TextButton(
//                     child: Text(
//                       controller.timerIsActive
//                           ? '${controller.timerCount.inSeconds}s'
//                           : 'Resend',
//                       style: const TextStyle(color: Colors.blue, fontSize: 18),
//                     ),
//                     onPressed: controller.timerIsActive
//                         ? null
//                         : () async {
//                             log(VerifyPhoneNumberScreen.id, msg: 'Resend OTP');
//                             await controller.sendOTP();
//                           },
//                   ),
//                 const SizedBox(width: 5),
//               ],
//             ),
//             body: controller.codeSent
//                 ? ListView(
//                     padding: const EdgeInsets.all(20),
//                     controller: scrollController,
//                     children: [
//                       Text(
//                         "We've sent an SMS with a verification code to ${widget.phoneNumber}",
//                         style: const TextStyle(fontSize: 25),
//                       ),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       if (controller.timerIsActive)
//                         Column(
//                           children: const [
//                             CustomLoader(),
//                             SizedBox(height: 50),
//                             Text(
//                               'Listening for OTP',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(height: 15),
//                             Divider(),
//                             Text('OR', textAlign: TextAlign.center),
//                             Divider(),
//                           ],
//                         ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         'Enter OTP',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       PinInputField(
//                         length: 6,
//                         onFocusChange: (hasFocus) async {
//                           if (hasFocus) await _scrollToBottomOnKeyboardOpen();
//                         },
//                         onSubmit: (enteredOTP) async {
//                           final isValidOTP = await controller.verifyOTP(
//                             otp: enteredOTP,
//                           );
//                           // Incorrect OTP
//                           if (!isValidOTP) {
//                             _showSnackBar(
//                                 context, 'The entered OTP is invalid!');
//                           }
//                         },
//                       ),
//                     ],
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CustomLoader(),
//                       SizedBox(height: 50),
//                       Center(
//                         child: Text(
//                           'Sending OTP',
//                           style: TextStyle(fontSize: 25),
//                         ),
//                       ),
//                     ],
//                   ),
//           );
//         },
//       ),
//     );
//   }
//   // @override
//   // Widget build(BuildContext context) {
//   //   return SafeArea(
//   //     child: FirebasePhoneAuthHandler(
//   //       phoneNumber: "+91${widget.phoneNumber}",
//   //       timeOutDuration: const Duration(seconds: 60),
//   //       onLoginSuccess: (userCredential, autoVerified) async {
//   //         _showSnackBar(
//   //           context,
//   //           'Phone number verified successfully!',
//   //         );
//   //         // createUser(name, phone);
//   //         Get.off(() => const CreatingUser());
//   //         // Constant.signInWithPhoneAuthCred(name, phone);
//   //         debugPrint(
//   //           autoVerified
//   //               ? "OTP was fetched automatically"
//   //               : "OTP was verified manually",
//   //         );

//   //         debugPrint("Login Success UID: ${userCredential.user?.uid}");
//   //       },
//   //       onLoginFailed: (authException) {
//   //         _showSnackBar(
//   //           context,
//   //           'Invalid otp)',
//   //         );

//   //         debugPrint(authException.message);
//   //         // handle error further if needed
//   //       },
//   //       builder: (context, controller) {
//   //         return Scaffold(
//   //           appBar: AppBar(
//   //             backgroundColor: Colors.transparent,
//   //             elevation: 0,
//   //             title: Text("Verify Phone Number",
//   //                 style: TextStyle(
//   //                   fontSize: Constant.height / 50,
//   //                 )),
//   //             toolbarHeight: Constant.height / 7,
//   //             centerTitle: true,
//   //             flexibleSpace: Container(
//   //               decoration: BoxDecoration(
//   //                 borderRadius: const BorderRadius.only(
//   //                     bottomLeft: Radius.circular(20),
//   //                     bottomRight: Radius.circular(20)),
//   //                 gradient: LinearGradient(
//   //                     colors: [Colors.pink, Colors.yellow.shade200],
//   //                     begin: Alignment.bottomCenter,
//   //                     end: Alignment.topCenter),
//   //               ),
//   //             ),
//   //             actions: [
//   //               if (controller.codeSent)
//   //                 TextButton(
//   //                   child: Text(
//   //                     controller.timerIsActive
//   //                         ? "${controller.timerCount.inSeconds}s"
//   //                         : "RESEND",
//   //                     style: const TextStyle(
//   //                       color: Colors.blue,
//   //                       fontSize: 18,
//   //                     ),
//   //                   ),
//   //                   onPressed: controller.timerIsActive
//   //                       ? null
//   //                       : () async => await controller.sendOTP(),
//   //                 ),
//   //               const SizedBox(width: 5),
//   //             ],
//   //           ),
//   //           body: controller.codeSent
//   //               ? ListView(
//   //                   padding: const EdgeInsets.all(20),
//   //                   children: [
//   //                     Text(
//   //                       "We've sent an SMS with a verification code to ${widget.phoneNumber}",
//   //                       style: const TextStyle(
//   //                         fontSize: 25,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 10),
//   //                     const Divider(),
//   //                     AnimatedContainer(
//   //                       duration: const Duration(seconds: 1),
//   //                       height: controller.timerIsActive ? null : 0,
//   //                       child: Column(
//   //                         children: const [
//   //                           CircularProgressIndicator.adaptive(),
//   //                           SizedBox(height: 50),
//   //                           Text(
//   //                             "Listening for OTP",
//   //                             textAlign: TextAlign.center,
//   //                             style: TextStyle(
//   //                               fontSize: 25,
//   //                               fontWeight: FontWeight.w600,
//   //                             ),
//   //                           ),
//   //                           Divider(),
//   //                           Text("OR", textAlign: TextAlign.center),
//   //                           Divider(),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                     const Text(
//   //                       "Enter OTP",
//   //                       style: TextStyle(
//   //                         fontSize: 20,
//   //                         fontWeight: FontWeight.w600,
//   //                       ),
//   //                     ),
//   //                     TextField(
//   //                       maxLength: 6,
//   //                       keyboardType: TextInputType.number,
//   //                       onChanged: (String v) async {
//   //                         _enteredOTP = v;
//   //                         if (_enteredOTP?.length == 6) {
//   //                           final isValidOTP = await controller.verifyOTP(
//   //                             otp: _enteredOTP!,
//   //                           );
//   //                           // Incorrect OTP
//   //                           if (!isValidOTP) {
//   //                             _showSnackBar(
//   //                               context,
//   //                               "Please enter the correct OTP sent to +91${widget.phoneNumber}",
//   //                             );
//   //                           }
//   //                         }
//   //                       },
//   //                     ),
//   //                   ],
//   //                 )
//   //               : Column(
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   crossAxisAlignment: CrossAxisAlignment.center,
//   //                   children: const [
//   //                     CircularProgressIndicator.adaptive(),
//   //                     SizedBox(height: 50),
//   //                     Center(
//   //                       child: Text(
//   //                         "Sending OTP",
//   //                         style: TextStyle(fontSize: 25),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

//   Future checkUserExist() async {
//     try {
//       //=====Getting list of all uid from documents raw_student_info
//       QueryDocumentSnapshot<Object?> Userid;
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("Raw_students_info")
//           .get();
//       for (int i = 0; i < querySnapshot.docs.length; i++) {
//         Userid = querySnapshot.docs[i];
//         if (Userid.id == constuid) {
//           // Document already exists
//           // if (Userid.id == constuid) {
//           Fluttertoast.showToast(msg: "alredy exist in students ");
//           print("User $constuid already exist and not necessary to be created");
//           // Timer(const Duration(milliseconds: 300),
//           //     () => Get.off(() => CompleteProfile()));
//           print("found in if condn");
//           Timer(const Duration(milliseconds: 300),
//               () => Get.off(() => HomePageNav()));
//           // / Navigator.of(context).pushAndRemoveUntil(
//           //     MaterialPageRoute(builder: (context) => CompleteProfile()),
//           //     (route) => false,

//           break;

//           // break;
//         } else {
//           print("i'm in else condition ");
//           print("not found in else condn");
//           // showDialogFirstTime();
//           // Timer(const Duration(milliseconds: 30),
//           //     () => Get.off(() => const HomePage()));
//           Timer(const Duration(milliseconds: 300),
//               () => Get.off(() => const CompleteProfile()));
//           // Timer(const Duration(milliseconds: 30),
//           //     () => Get.off(() => const HomePage()));
//         }
//         print(Userid.id);
//       }
//     } catch (e) {
//       print("erroe caught: $e");
//       Fluttertoast.showToast(msg: "error: $e");
//     }
//   }

//   void signInWithPhoneAuthCred(String name, String phone) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     try {
//       // final authCred = await _auth.signInWithCredential(phoneAuthCredential);

//       if (_auth.currentUser != null) {
//         LocalData.saveName(name);
//         LocalData.savePhone(phone);
//         var getPhone = LocalData.getPhone();
//         if (phone != getPhone.toString()) {
//           await LocalData.saveFirstTime(false);
//         } else {}
//         checkUserExist();
//       }
//     } on FirebaseAuthException catch (e) {
//       print(e.message);

//       Fluttertoast.showToast(msg: e.message.toString());
//     }
//   }
// }
