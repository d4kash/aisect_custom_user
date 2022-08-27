import 'package:aisect_custom/google/lib/services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/constant.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  RxBool isLoading = false.obs;
  var c = Get.put(ButtonController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => c.isLoading.isFalse
        ? Container(
            padding: EdgeInsets.all(4),
            child: OutlinedButton.icon(
              label: Text(
                'Sign In With Google',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              onPressed: () async {
                c.isLoading.value = true;
                await Future.delayed(Duration(milliseconds: 300));

                context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                // c.isLoading.value = false;
              },
            ),
          )
        : Constant.circle());
  }
}

class ButtonController extends GetxController {
  RxBool isLoading = false.obs;
}
