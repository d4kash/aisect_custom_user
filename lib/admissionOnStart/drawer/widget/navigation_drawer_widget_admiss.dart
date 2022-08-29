import 'dart:async';

import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/drawer/model/drawer_item.dart';
import 'package:aisect_custom/admissionOnStart/drawer/page/profile.dart';
import 'package:aisect_custom/admissionOnStart/notice/notice_section_admission.dart';
import 'package:aisect_custom/admissionOnStart/drawer/data/drawer_items.dart';

import 'package:aisect_custom/admissionOnStart/drawer/page/Logout.dart';
import 'package:aisect_custom/admissionOnStart/drawer/page/about.dart';
import 'package:aisect_custom/admissionOnStart/drawer/page/help.dart';

import 'package:aisect_custom/admissionOnStart/drawer/provider/navigation_provider.dart';
import 'package:aisect_custom/google/widget/sign_up_widget.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';

import 'package:aisect_custom/services/constant.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidgetAdmission extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProviderAdmission>(context);
    final isCollapsed = provider.isCollapsed;

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Color(0xFF1a2f45),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                height: height / 6,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              SizedBox(height: height / 60),
              buildList(items: itemsFirst, isCollapsed: isCollapsed),
              SizedBox(height: height / 60),
              Divider(color: Colors.white70),
              SizedBox(height: height / 60),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: height / 60),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(AdmissionHome());
        break;
      case 1:
        navigateTo(Profile());
        break;
      case 2:
        navigateTo(NoticeAdmission());
        break;
      case 3:
        navigateTo(HelpPage());
        break;
      case 4:
        navigateTo(AboutPage());
        break;
      case 5:
        navigateTo(LogoutPage());
        // Get.defaultDialog(
        //   title: 'Sure! Want to Logout ',
        //   middleText: '',
        //   textConfirm: 'Logout',
        //   onConfirm: (() async {
        //     print('logout');
        //     try {
        //       await FirebaseAuth.instance.signOut().then((value) {
        //         print("success");
        //         navigateUser(context);
        //         // Get.offAndToNamed(AppRoutes.signup);
        //       });
        //       print("success done");
        //     } on FirebaseAuthException catch (e) {
        //       print('erroe ${e}');
        //       Constant.showSnackBar(
        //           context, e.message!); // Displaying the error message
        //     }
        //   }),
        // );

        break;
    }
  }

  navigateUser(
    BuildContext context,
  ) async {
    FirebaseAuth _auth = await FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      await Timer(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AdmissionHome()),
              (route) => false));
    } else {
      await Timer(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignUpWidget()),
              (route) => false));
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider = Provider.of<NavigationProviderAdmission>(context,
                listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? Image.asset(
          "assets/images/ic_launcher_round.png",
          scale: 3,
        )
      : Row(
          children: [
            const SizedBox(width: 24),
            Image.asset(
              "assets/images/ic_launcher_round.png",
              scale: 2,
            ),
            const SizedBox(width: 16),
            Text(
              'Aisect',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}
