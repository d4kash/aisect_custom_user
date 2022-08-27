// ignore_for_file: must_be_immutable

import 'package:aisect_custom/video/screens/history_meeting_screen.dart';
import 'package:aisect_custom/video/screens/meeting_screen.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MettingHomePage extends StatefulWidget {
  MettingHomePage({Key? key, this.ctrl}) : super(key: key);
  var ctrl;
  @override
  _MettingHomePageState createState() => _MettingHomePageState();
}

class _MettingHomePageState extends State<MettingHomePage> {
  RxInt index = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBarScreen(
            title: "Meetings",
          ),
          body: bodySection(),
          bottomNavigationBar: customBottomNavigationBar(),
        ));
  }

// * Body Section Components
  bodySection() {
    switch (index.toInt()) {
      case 0:
        return MeetingScreen();
      case 1:
        return const HistoryMeetingScreen();
      case 2:
        return const Text('Contacts');
      // case 3:
      //   return CustomButton(
      //       text: 'Log Out', onPressed: () => AuthMethods().signOut());
    }
  }

// * BottomNavigationBar Section Components
  customBottomNavigationBar() {
    return Obx(() => BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: index.toInt(),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.comment_bank),
            title: Text('Meet & Chat'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.lock_clock),
              title: Text('Meetings'),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.contact_page),
              title: Text('Contact'),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center),
          // BottomNavyBarItem(
          //     icon: Icon(Icons.settings),
          //     title: Text('Settings'),
          //     activeColor: Colors.purpleAccent,
          //     textAlign: TextAlign.center),
        ],
        onItemSelected: (index) => this.index.value = index));
  }
}
