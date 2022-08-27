// import 'dart:async';

// import 'package:aisect_custom/Network/connectivity_provider.dart';
// import 'package:aisect_custom/Network/no_internet.dart';
// import 'package:aisect_custom/auth/LoginHomeScreen.dart';
// import 'package:aisect_custom/auth/finger_auth/LoadingScreen.dart';

// import 'package:aisect_custom/inside_Admis/Apply.dart';
// import 'package:aisect_custom/inside_Admis/Courses_Fee.dart';
// import 'package:aisect_custom/inside_Admis/Enquiry.dart';

// import 'package:aisect_custom/inside_Admis/status.dart';
// import 'package:aisect_custom/Home/drawerConfig/Logout.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:provider/provider.dart';

// import 'package:velocity_x/velocity_x.dart';

// // import 'app_colors.dart';

// class ApplicationOnStart extends StatefulWidget {
//   const ApplicationOnStart({Key? key}) : super(key: key);

//   @override
//   _ApplicationOnStartState createState() => _ApplicationOnStartState();
// }

// class _ApplicationOnStartState extends State<ApplicationOnStart>
//     with TickerProviderStateMixin {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;
//   String? uid = "";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   Future navigateUser() async {
//     print(" in navigate user");
//     if (_auth.currentUser != null) {
//       String uid = _auth.currentUser!.uid.toString();
//       final snapShot = await FirebaseFirestore.instance
//           .collection('Raw_students_info')
//           .doc(uid)
//           .get();
//       print(snapShot.exists);
//       if (snapShot.exists == true) {
//         Timer(
//             Duration(milliseconds: 30),
//             () => Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => BiometricAuth()),
//                 (route) => false));
//       } else {
//         Timer(
//             Duration(milliseconds: 30),
//             () => Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => ApplicationOnStart()),
//                 (route) => false));
//       }
//     } else {
//       print("checkUserExist(); navigate in else");
//       Timer(
//           Duration(milliseconds: 40),
//           () => Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => HomePageForauth())));
//     }
//   }

//   Timer? _timer;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ConnectivityProvider>(
//         builder: (consumerContext, model, child) {
//       if (model.isOnline != null) {
//         return model.isOnline
//             ? Scaffold(
//                 body: NestedScrollView(
//                 headerSliverBuilder:
//                     (BuildContext context, bool innerBoxScrolled) {
//                   return <Widget>[
//                     SliverAppBar(
//                       expandedHeight: 250.0,
//                       floating: false,
//                       pinned: true,
//                       flexibleSpace: FlexibleSpaceBar(
//                         centerTitle: true,
//                         titlePadding: EdgeInsets.only(bottom: 15),
//                         title: Text(
//                           " Admission",
//                           style: GoogleFonts.montserrat(
//                               fontWeight: FontWeight.bold, fontSize: 25.0),
//                         ),
//                         background: Container(
//                           child: Material(
//                             child: SafeArea(
//                               child: Column(
//                                 children: [
//                                   Image.asset("assets/images/aisect1.png",
//                                       fit: BoxFit.contain)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ];
//                 },
//                 body: Hero(
//                   tag: "ADMISSION",
//                   child: Container(
//                     child: containerBox(context),
//                   ),
//                 ),
//               ))
//             : NoInternet();
//       }
//       ;
//       return Container(
//         child: Center(
//           child: SpinKitDoubleBounce(),
//         ),
//       );
//     });
//   }

//   containerBox(BuildContext context) {
//     //double width = MediaQuery.of(context).size.width;
//     // double height1 = MediaQuery.of(context).size.height;
//     return Material(
//       child: Column(
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(0),
//                 topRight: const Radius.circular(60),
//               ),
//               child: SingleChildScrollView(
//                 child: VxBox(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               "Prepare Yourself"
//                                   .richText
//                                   .size(20)
//                                   .bold
//                                   .letterSpacing(5)
//                                   .cyan500
//                                   .make(),
//                               "Don't Stop your mind"
//                                   .text
//                                   .start
//                                   .black
//                                   .headline6(context)
//                                   .make(),
//                               Center(
//                                 child: InkWell(
//                                   child: VxBox(
//                                     child: 'Inquiry'
//                                         .text
//                                         .xl4
//                                         .center
//                                         .bold
//                                         .makeCentered()
//                                         .cornerRadius(50)
//                                         .card
//                                         .rounded
//                                         .make(),
//                                   ).height(65).width(230).shadow5xl.make(),
//                                   onTap: () async {
//                                     Widget widget1 = EnquiryForm();
//                                     _timer?.cancel();
//                                     Future.delayed(Duration(seconds: 3));
//                                     await EasyLoading.show(
//                                         status: 'loading...');
//                                     EasyLoading.dismiss();
//                                     // Navigator.push(
//                                     //     context, CustomNavigation(widget1));
//                                     Get.to(() => widget1);
//                                   },
//                                 ),
//                               ),
//                               //Spacer(flex: 37),
//                               InkWell(
//                                 child: VxBox(
//                                   child: 'Courses & Fees'
//                                       .text
//                                       .size(30)
//                                       .center
//                                       .bold
//                                       .makeCentered()
//                                       .cornerRadius(50)
//                                       .card
//                                       .rounded
//                                       .make(),
//                                 ).height(65).width(230).shadow5xl.make(),
//                                 onTap: () async {
//                                   // showLoaderDialog(context);
//                                   _timer?.cancel();

//                                   Widget widget1 = CourseFee();
//                                   Future.delayed(Duration(seconds: 3));
//                                   await EasyLoading.show(status: 'loading...');
//                                   EasyLoading.dismiss();
//                                   // Navigator.push(
//                                   //     context, CustomNavigation(widget1));
//                                   Get.to(() => widget1);
//                                 },
//                               ),
//                               //Spacer(flex: 36),
//                               InkWell(
//                                 child: VxBox(
//                                   child: 'Apply'
//                                       .text
//                                       .xl4
//                                       .center
//                                       .bold
//                                       .makeCentered()
//                                       .cornerRadius(50)
//                                       .card
//                                       .rounded
//                                       .make(),
//                                 ).height(65).width(230).shadow5xl.make(),
//                                 onTap: () async {
//                                   // showLoaderDialog(context);
//                                   Widget widget1 = ApplyForAdmission();
//                                   _timer?.cancel();
//                                   Future.delayed(Duration(seconds: 10));
//                                   await EasyLoading.show(status: 'loading...');
//                                   EasyLoading.dismiss();
//                                   // Navigator.push(
//                                   //     context, CustomNavigation(widget1));
//                                   Get.to(() => widget1);
//                                 },
//                               ),
//                               //Spacer(flex: 36),
//                               InkWell(
//                                 child: VxBox(
//                                   child: 'Status'
//                                       .text
//                                       .xl4
//                                       .center
//                                       .bold
//                                       .makeCentered()
//                                       .cornerRadius(50)
//                                       .card
//                                       .rounded
//                                       .make(),
//                                 ).height(65).width(230).shadow5xl.make(),
//                                 onTap: () async {
//                                   Widget widget1 = ApplicationStatus();
//                                   _timer?.cancel();
//                                   Future.delayed(Duration(seconds: 3));
//                                   await EasyLoading.show(status: 'loading...');
//                                   EasyLoading.dismiss();
//                                   // Navigator.push(
//                                   //     context, CustomNavigation(widget1));
//                                   Get.to(() => widget1);
//                                 },
//                               ),
//                               InkWell(
//                                 child: VxBox(
//                                   child: 'Logout'
//                                       .text
//                                       .xl4
//                                       .center
//                                       .bold
//                                       .makeCentered()
//                                       .cornerRadius(50)
//                                       .card
//                                       .rounded
//                                       .make(),
//                                 ).height(65).width(230).shadow5xl.make(),
//                                 onTap: () async {
//                                   Widget widget1 = LogoutPage();
//                                   _timer?.cancel();
//                                   Future.delayed(Duration(seconds: 3));
//                                   await EasyLoading.show(status: 'loading...');
//                                   EasyLoading.dismiss();
//                                   // Navigator.push(
//                                   //     context, CustomNavigation(widget1));
//                                   Get.to(() => widget1);
//                                 },
//                               ),
//                               InkWell(
//                                 child: VxBox(
//                                   child: 'Application List'
//                                       .text
//                                       .size(28)
//                                       .center
//                                       .bold
//                                       .makeCentered()
//                                       .cornerRadius(50)
//                                       .card
//                                       .rounded
//                                       .make(),
//                                 ).height(65).width(230).shadow5xl.make(),
//                                 onTap: () async {
//                                   // Widget widget1 = UserInformation();
//                                   // _timer?.cancel();
//                                   // Future.delayed(Duration(seconds: 3));
//                                   // await EasyLoading.show(status: 'loading...');
//                                   // EasyLoading.dismiss();
//                                   // // Navigator.push(
//                                   // //     context, CustomNavigation(widget1));
//                                   // Get.to(() => widget1);
//                                   await navigateUser();
//                                 },
//                               ),
//                               // InkWell(
//                               //   child: VxBox(
//                               //     child: 'Accepted List'
//                               //         .text
//                               //         .size(28)
//                               //         .center
//                               //         .bold
//                               //         .makeCentered()
//                               //         .cornerRadius(50)
//                               //         .card
//                               //         .rounded
//                               //         .make(),
//                               //   ).height(65).width(230).shadow5xl.make(),
//                               //   onTap: () async {
//                               //     Widget widget1 = AcceptedUserInfo();
//                               //     _timer?.cancel();
//                               //     Future.delayed(Duration(seconds: 3));
//                               //     await EasyLoading.show(status: 'loading...');
//                               //     EasyLoading.dismiss();
//                               //     // Navigator.push(
//                               //     //     context, CustomNavigation(widget1));
//                               //     Get.to(() => widget1);
//                               //   },
//                               // ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ).white.p1.make(),
//               )).expand()
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/inside_Admis/Apply.dart';

import 'package:aisect_custom/inside_Admis/Enquiry.dart';
import 'package:aisect_custom/inside_Admis/status.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:animations/animations.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aisect_custom/inside_Admis/course.dart';

class ApplicationOnStart extends StatefulWidget {
  const ApplicationOnStart({Key? key}) : super(key: key);

  @override
  _ApplicationOnStartState createState() => _ApplicationOnStartState();
}

class _ApplicationOnStartState extends State<ApplicationOnStart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final cont = Get.put(widget());

  bool innerBoxScrolled = true;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Admission",
            style: TextStyle(
              fontSize: Constant.height / 25,
            )),
        toolbarHeight: Constant.height / 7,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.yellow.shade200],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: Hero(
        tag: "ADMISSION",
        child: containerBox(context),
      ),
      // ),
    );
  }

  containerBox(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Row(children: [
          Column(
            children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 0);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const EnquiryForm();
                },
              ),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 1);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const Fee();
                },
              ),
            ],
          ),
          SizedBox(
            width: Constant.width / 38,
          ),
          Padding(
            padding: EdgeInsets.only(top: Constant.height / 10),
            child: Column(children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 2);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return const ApplyForAdmission();
                },
              ),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: const Color(0xffe7f0fd),
                openColor: const Color(0xffe7f0fd),
                middleColor: const Color(0xffe7f0fd),
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: const Duration(milliseconds: 800),
                closedBuilder: (BuildContext context, void Function() action) {
                  return cont.container(color, icons, titles, 3);
                },
                openBuilder: (BuildContext context,
                    void Function({Object? returnValue}) action) {
                  return ApplicationStatus();
                },
              ),
            ]),
          ),
        ]));
  }

  final List<String> titles = [
    "INQUIRY",
    "COURSE & FEE",
    "APPLY",
    "STATUS",
  ];
  final List<IconData> icons = [
    CarbonIcons.add,
    CarbonIcons.exam_mode,
    CarbonIcons.activity,
    CarbonIcons.forum,
  ];
  final List<Widget> page = [
    const EnquiryForm(),
    const Fee(),
    const ApplyForAdmission(),
    ApplicationStatus()
  ];

  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    // [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];

  Widget container(final List<List<Color>> color, final List<IconData> icons,
      final List<String> titles, final int index, List<Widget> page) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 20),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            child: Container(
              height: Get.size.height / 3.3,
              width: Get.size.width / 2.5,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                // color: Colors.grey,
                gradient: LinearGradient(
                  colors: color[index],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    size: Get.size.height / 18,
                  ),
                  SizedBox(
                    height: Get.size.height / 25,
                  ),
                  Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: Get.size.height / 35,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              // _timer?.cancel();
              // await Future.delayed(const Duration(seconds: 3));
              // await EasyLoading.show(status: 'building...');
              // EasyLoading.dismiss();
              Get.to(() => page[index]);
            },
          ),
        ),
      ]),
    );
  }
}
//  _timer?.cancel();
//                   await EasyLoading.show(status: 'loading...');
//                   await Future.delayed(const Duration(seconds: 3));

//                   EasyLoading.dismiss();
//                   Get.to(() => const EnquiryForm());