import 'package:aisect_custom/GetController/authController.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/auth/controllers/authentications.dart';
import 'package:aisect_custom/auth/signup.dart';
import 'package:aisect_custom/utils/image_links.dart';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

// import 'animation/FadeAnimation.dart';
// import 'package:login_page_day_23/animation/FadeAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Login to your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 40),
                    //   child: Column(
                    //     children: <Widget>[
                    //       FadeAnimation(
                    //           1.2,
                    //           makeInput(
                    //               label: "Email", controller: emailController)),
                    //       FadeAnimation(
                    //           1.3,
                    //           makeInput(
                    //               label: "Password",
                    //               obscureText: true,
                    //               controller: passwordController)),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                            // var value = await signIn(
                            //     email: emailController.text.trim(),
                            //     password: passwordController.text.trim());
                            // if (value == true) {
                            //   print("pass");
                            //   Navigator.push(
                            //       context,
                            //       new MaterialPageRoute(
                            //           builder: (BuildContext context) =>
                            //               new zoomDrawerHome()));
                            //   print(value);
                            // } else {
                            //   print("failed");

                            // }
                            var value = signInUsingEmailPassword(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                            if (value ==
                                "Ignoring header X-Firebase-Locale because its value was null") {
                              print("null");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePageNav()));
                            }
                          },
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    ),

                    SignInButton(Buttons.Google, onPressed: () {
                      var usr = signInWithGoogleFun();
                      print("$usr from login screen");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomePageNav(),
                        ),
                      );
                    }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don't have an account?",
                          style: const TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new SignupPage())),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:  NetworkImage(phoneMain),
                        fit: BoxFit.cover)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false, controller, validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validator,
          controller: controller,
          style: const TextStyle(color: Colors.black54),
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
