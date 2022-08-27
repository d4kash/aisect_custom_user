import 'package:aisect_custom/admissionOnStart/PhoneAuthForAdmission.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/utils/image_links.dart';
import 'package:flutter/material.dart';
import 'PhoneAuth.dart';

class HomePageForauth extends StatelessWidget {
  const HomePageForauth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Automatic identity verification which enables you to verify your identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
              Container(
                height: Constant.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(phoneauth),
                )),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      //! Fordard to phone auth verification for get access
                      // Get.to(() => Authenticate());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginA())); //PhoneAuth.dart
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Access For Students",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
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
                      onPressed: () {
                        //! Fordward to phone auth verification
                        // Get.to(() => Authenticate());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginForAdmission()));
                      },
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Admission Section",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
