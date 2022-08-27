import 'package:aisect_custom/Authenticate/Autheticate.dart';
import 'package:aisect_custom/google/lib/services/firebase_auth_methods.dart';
import 'package:aisect_custom/routes/app_routes.dart';
import 'package:aisect_custom/services/LocalData.dart';
import 'package:aisect_custom/video/widgets/meeting_option.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:aisect_custom/widget/toggle_design/toggleButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:aisect_custom/google/widget/background_painter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  // var c = Get.put(ButtonController());
  RxBool isLoading = false.obs;
  RxBool isAdmission = false.obs;
  RxBool isStudent = true.obs;
  RxString selected = 'none'.obs;
  RxInt _toggleValue = 0.obs;
  List<String> selectSlide = ['admission', 'student'];
  SignUpWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: BackgroundPainter()),
        buildSignUp(context),
      ],
    );
  }

  Widget buildSignUp(BuildContext context) {
    // List radioList = ["Login For Admission", "Login For Student"];

    // Rx<access?> selectedValue = Rx<access?>(access.none);

    return Obx(() => isLoading.isFalse
        ? Column(
            children: [
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: 175,
                  child: Text(
                    'Welcome Back To Aisect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Spacer(),
              SizedBox(height: height / 4.5),

              SizedBox(
                width: width / 1.5,
                height: height / 6,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please Select For Login:',
                          style: TextStyle(fontSize: 20)),
                    ),
                    AnimatedToggle(
                      values: selectSlide,
                      onToggleCallback: (value) {
                        _toggleValue.value = value;
                        if (value == 0) {
                          selected.value = selectSlide[0];
                          print(selected.value);
                        } else {
                          selected.value = selectSlide[1];
                          print(selected.value);
                        }
                      },
                      buttonColor: selected.value == 'none'
                          ? Color.fromARGB(255, 145, 156, 167)
                          : const Color(0xFF0A3157),
                      backgroundColor: const Color(0xFFB5C1CC),
                      textColor: const Color(0xFFFFFFFF),
                    ),
                    // Text('Toggle Value : ${_toggleValue}'),
                    // MeetingOption(
                    //   text: 'Student Section',
                    //   isMute: ctrl.isStudent.value,
                    //   onChange: ctrl.onVideoMuted,
                    // ),
                    // MeetingOption(
                    //   text: 'Admission Section',
                    //   isMute: ctrl.isAdmission.value,
                    //   onChange: ctrl.onAudioMuted,
                    // ),
                  ],
                ),
                // ),
              ),
              SizedBox(
                height: height / 8,
              ),
              CustomButtonNew(
                text: "Choose Login",
                onPressed: () {
                  if (selected.toString() != "none") {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            SizedBox(height: height / 20),
                            Text(
                              'Login to continue to ${selected.toString()}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              child: OutlinedButton.icon(
                                label: Text(
                                  'Sign In With Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                style: OutlinedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                icon: FaIcon(FontAwesomeIcons.google,
                                    color: Colors.red),
                                onPressed: () async {
                                  if (selected.toString() != "none") {
                                    isLoading.value = true;
                                    if (selected.toString() == selectSlide[0]) {
                                      debugPrint(selectSlide[0]);
                                      await LocalData.saveName("admission");
                                      context
                                          .read<FirebaseAuthMethods>()
                                          .signInWithGoogleAdmission(
                                              context, "admission");
                                      await Future.delayed(
                                          Duration(seconds: 5));
                                    } else {
                                      context
                                          .read<FirebaseAuthMethods>()
                                          .signInWithGoogle(context);
                                      await Future.delayed(
                                          Duration(seconds: 5));
                                    }
                                    isLoading.value = false;
                                  } else {
                                    Constant.showSnackBar(
                                        context, "Please choose section");
                                    Fluttertoast.showToast(
                                        msg: 'Please choose section');
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: height / 20),
                            CustomButtonNew(
                              text: "Email Login",
                              onPressed: () async {
                                if (selected.toString() != "none") {
                                  isLoading.value = true;
                                  if (selected.toString() == selectSlide[0]) {
                                    debugPrint(selectSlide[0]);
                                    await LocalData.saveName("admission");
                                    // Navigator.pushNamed(
                                    //     context, AppRoutes.gmailLogin);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Authenticate(
                                                selectedDetails: "admission")));
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.gmailLogin);
                                  }
                                  isLoading.value = false;
                                } else {
                                  Constant.showSnackBar(
                                      context, "Please choose section");
                                  Fluttertoast.showToast(
                                      msg: 'Please choose section');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Constant.showSnackBar(
                    //     context, "Please choose between admission & student");
                    Fluttertoast.showToast(
                        msg: 'Please choose between admission & student');
                  }
                },
              ),
              SizedBox(
                height: height / 20,
              ),
            ],
          )
        : Constant.circle());
  }
}
