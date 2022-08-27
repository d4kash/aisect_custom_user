import 'package:aisect_custom/Home/HomePage%20copy.dart';
import 'package:aisect_custom/video/screens/home_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageNav extends StatefulWidget {
  HomePageNav({Key? key, this.ctrl}) : super(key: key);
  var ctrl;
  @override
  _HomePageNavState createState() => _HomePageNavState();
}

class _HomePageNavState extends State<HomePageNav> {
  RxInt index = 0.obs;
  @override
  void initState() {
    permissionRequest();
    super.initState();
  }

  void permissionRequest() async => await checkallpermission_openstorage();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: bodySection(),
          bottomNavigationBar: customBottomNavigationBar(),
        ));
  }

// * Body Section Components
  bodySection() {
    switch (index.toInt()) {
      case 0:
        return HomePage(ctrl: widget.ctrl);
      case 1:
        return MettingHomePage();
    }
  }

// * BottomNavigationBar Section Components
  customBottomNavigationBar() {
    return Obx(() => BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: index.toInt(),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.video_call),
              title: Text('Meeting'),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center),
        ],
        onItemSelected: (index) => this.index.value = index));
  }

  checkallpermission_openstorage() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
    } else {
      Fluttertoast.showToast(
          msg: "Please Provide Storage permission to use storage.");
    }
  }

  checkpermission_openstorage() async {
    var storageStatus = await Permission.camera.status;
    // var microphoneStatus = await Permission.microphone.status;

    print(storageStatus);
    // print(microphoneStatus);
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission.
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission.
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission.
    //cameraStatus.isUndetermined == permission has not asked before.

    if (!storageStatus.isGranted) await Permission.storage.request();

    // if (!microphoneStatus.isGranted) await Permission.microphone.request();

    if (await Permission.storage.isGranted) {
    } else {
      Fluttertoast.showToast(
        msg: "Provide storage permission to use storage.",
      );
    }
  }
}
