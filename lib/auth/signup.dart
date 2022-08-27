// import 'dart:html';

import 'package:aisect_custom/auth/controllers/authentications.dart';
import 'package:aisect_custom/auth/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'PhoneAuth.dart';

enum LoginorOtp { SHOW_MOBILE_ENTER, SHOW_OTP_ENTER }

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  LoginorOtp currentState = LoginorOtp.SHOW_MOBILE_ENTER;
  late Future<FirebaseApp> _firebaseApp;
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfpassController = TextEditingController();
  final RegExp emailRegex =
      new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");

  static const IconData call = IconData(0xe126, fontFamily: 'MaterialIcons');

  var pass;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account, It's free",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                // Column(
                //   children: <Widget>[
                //
                //
                //         makeInput(
                //             controller: emailController,
                //             label: "Email",
                //             name1: TextInputType.emailAddress,
                //             validator: (val) {
                //               var phone = emailController.text;
                //               bool emailValid = phoneRegex.hasMatch(phone);
                //               if (emailController.text.isEmpty ||
                //                   emailController.text.length < 10 ||
                //                   emailValid == false) {
                //                 // print("null phone no");
                //                 Fluttertoast.showToast(
                //                     msg: "Fool! Give me Food :(",
                //                     toastLength: Toast.LENGTH_SHORT,
                //                     gravity: ToastGravity.BOTTOM,
                //                     timeInSecForIosWeb: 1,
                //                     backgroundColor: Colors.red,
                //                     textColor: Colors.white,
                //                     fontSize: 16.0);
                //               }
                //             })),
                //
                //
                //         makeInput(
                //             controller: passwordController,
                //             label: "Password",
                //             obscureText: true,
                //             maxlength: 8,
                //             name1: TextInputType.name,
                //             validator: (val) {
                //               if (val < 8) {
                //                 return "must be 8 digit";
                //               }
                //               setState(() {
                //                 pass = val;
                //               });
                //             })),
                //
                //
                //         makeInput(
                //             controller: cnfpassController,
                //             label: "Confirm Password",
                //             obscureText: true,
                //             maxlength: 8,
                //             name1: TextInputType.name,
                //             validator: (val) {})),
                //   ],
                // ),

                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      // signUp(
                      //     email: emailController.text.trim(),
                      //     password: passwordController.text.trim());
                      // Navigator.pushReplacement(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             new LoginPage()));
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),

                MaterialButton(
                  elevation: 20,
                  highlightElevation: 20,
                  height: 30,
                  child: Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          call,
                          color: Colors.indigo,
                        ),
                        Text(
                          "Go With Phone",
                          style: TextStyle(
                            color: Colors.indigo[200],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LoginA())); //PhoneAuth
                  },
                ),

                SignInButton(Buttons.Google, onPressed: () {
                  signInWithGoogleFun().whenComplete(() => null); //Email Auth
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new LoginPage())),
                      child: Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label, obscureText = false, maxlength, name1, validator, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 0,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: name1,
          maxLength: maxlength,
          obscureText: obscureText,
          style: TextStyle(color: Colors.black54),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        SizedBox(
          height: 0,
        ),
      ],
    );
  }
}
