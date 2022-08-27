import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
// import 'package:aisect_custom/google/lib/utils/showOtpDialog.dart';
// import 'package:aisect_custom/google/lib/utils/showSnackbar.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:aisect_custom/routes/app_routes.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Home/CompleteProfile.dart';
import '../../../firebase_helper/FirebaseConstants.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      Constant.showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      }
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      Constant.showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // googleProvider
        //     .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              checkUserExist(context);
            } else {
              checkUserExist(context);
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  Future<void> signInWithGoogleAdmission(
      BuildContext context, String admission) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // googleProvider
        //     .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              checkUserExistAdmission(context);
            } else {
              checkUserExistAdmission(context);
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollectionRef =
      _firestore.collection("New_Admission_Request");
//! creating user for Admission
  static Future createUserAdmission() async {
    try {
      await _userCollectionRef.doc(constuid).set({
        'admission-section': true,
      });
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  static bool isSearching = false;
  static Future checkUserExistAdmission(BuildContext context) async {
    try {
      //=====Getting list of all uid from documents raw_student_info
      QueryDocumentSnapshot<Object?> Userid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("New_Admission_Request")
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        Userid = querySnapshot.docs[i];
        if (Userid.id == constuid) {
          // Document already exists
          // if (Userid.id == constuid) {
          Fluttertoast.showToast(msg: "Success");
          print("User $constuid already exist and not necessary to be created");

          print("found in if condn");
          Timer(const Duration(seconds: 3),
              () => Navigator.pushNamed(context, AppRoutes.admissionHome));
// isSearching = false;
          break;
        } else {
          print("i'm in else condition ");
          print("not found in else condn");
          createUserAdmission();
          Timer(const Duration(seconds: 3),
              () => Navigator.pushNamed(context, AppRoutes.admissionHome));
          // isSearching = false;
        }
        print(Userid.id);
      }
    } catch (e) {
      print("erroe caught: $e");
      Fluttertoast.showToast(msg: "error: $e");
    }
  }

  static Future checkUserExist(BuildContext context) async {
    try {
      //=====Getting list of all uid from documents raw_student_info
      QueryDocumentSnapshot<Object?> Userid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Raw_students_info")
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        Userid = querySnapshot.docs[i];
        if (Userid.id == constuid) {
          // Document already exists
          // if (Userid.id == constuid) {
          Fluttertoast.showToast(msg: "Success");
          print("User $constuid already exist and not necessary to be created");

          print("found in if condn");
          Timer(const Duration(seconds: 3), () => Get.off(() => HomePageNav()));
// isSearching = false;
          break;
        } else {
          print("i'm in else condition ");
          print("not found in else condn");

          Timer(const Duration(seconds: 3),
              () => Get.off(() => const CompleteProfile()));
          // isSearching = false;
        }
        print(Userid.id);
      }
    } catch (e) {
      print("erroe caught: $e");
      Fluttertoast.showToast(msg: "error: $e");
    }
  }

  showToast(String error) {
    Fluttertoast.showToast(msg: error);
  }

  // ANONYMOUS SIGN IN
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  // FACEBOOK SIGN IN
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      // // Diplay Dialog Box To accept OTP
      // showOTPDialog(
      //   codeController: codeController,
      //   context: context,
      //   onPressed: () async {
      //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //       verificationId: result.verificationId,
      //       smsCode: codeController.text.trim(),
      //     );

      //     await _auth.signInWithCredential(credential);
      //     Navigator.of(context).pop(); // Remove the dialog box
      //   },
      // );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          Constant.showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          // showOTPDialog(
          //   codeController: codeController,
          //   context: context,
          //   onPressed: () async {
          //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
          //       verificationId: verificationId,
          //       smsCode: codeController.text.trim(),
          //     );

          //     // !!! Works only on Android, iOS !!!
          //     await _auth.signInWithCredential(credential);
          //     Navigator.of(context).pop(); // Remove the dialog box
          //   },
          // );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      final FirebaseAuth _auth = await FirebaseAuth.instance;
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      Constant.showSnackBar(
          context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
