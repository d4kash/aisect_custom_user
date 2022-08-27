import 'dart:io';
import 'dart:math';

import 'package:aisect_custom/drawer/provider/navigation_provider.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/firebase_helper/jsontofirebase.dart';
import 'package:aisect_custom/firebase_options.dart';
import 'package:aisect_custom/google/lib/services/firebase_auth_methods.dart';

import 'package:aisect_custom/notification/notification_service.dart';
import 'package:aisect_custom/payment/paytm_payment.dart';

import 'package:aisect_custom/routes/app_pages.dart';

import 'package:aisect_custom/services/constant.dart';

import 'package:aisect_custom/widget/CustomAnimationLoading.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Network/connectivity_provider.dart';
import 'Splash/SplashScreen.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: 'create',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    HttpOverrides.global = MyHttpOverrides();
    print("initialize work manager");
    await Workmanager().initialize(callbackDispatcher);
    startNotification();

    print("work manager done");

    // await NotificationService().init();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // configLoading();
    // await initialization(null);
    //     );
  } on Exception catch (e) {
    print("something went wrong: $e");
  }

  runApp(const MyApp());
}

const fetchBackground = "fetchBackground";
startNotification() async {
  // var random = Random();
  print('hitted');

  try {
    await Workmanager().registerPeriodicTask(
      "fetch",
      "fetchBackground",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(hours: 4),
      initialDelay: Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  } catch (e) {
    print("periodic init: $e");
  }
}

void callbackDispatcher() async {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case 'fetchBackground':
          try {
            print('in callback');

            await Firebase.initializeApp(
              name: 'create',
              options: DefaultFirebaseOptions.currentPlatform,
            );

            await NotificationService().init();

            await onClick();
            print('running workmanager');
          } catch (e) {
            print("error in init firebaseApp: $e");
          }
          break;
        default:
      }
      return Future.value(true);
    });
  } catch (e) {
    print('running workmanager error : ${e}');
  }
}

onClick() async {
  var random = Random();

  final _notificationService = NotificationService();
  try {
    var _auth = await FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      print(_auth.currentUser!.uid);
      var noticeList = await FirestoreMethods.getNoticeStudents();

      noticeList.students.forEach((notification) async {
        if (notification.read == false) {
          // Fluttertoast.showToast(msg: '${notification.notice_no}');
          await _notificationService.showNotifications(random.nextInt(1000),
              notification.notice_title, notification.notice_message);
        }
        // Fluttertoast.showToast(msg: '${notification.notice_no}');
      });
    } else {
      await _notificationService.showNotifications(
          random.nextInt(1000),
          "AISECT UNIVERSITY",
          " Welcome to our family,\nwe are happy to serve you");
    }
  } on Exception catch (e) {
    print(e);
  }
}

// Future initialization(BuildContext? context) async {
//   await Future.delayed(Duration(seconds: 1));
// }

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 400)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = const Color.fromARGB(255, 116, 126, 183)
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = const Color.fromARGB(255, 247, 147, 228).withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

// ignore: public_member_api_docs`
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    // startNotification();
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (context) => ConnectivityProvider(),
          child: const SplashScreen(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (context) => NavigationProvider(),
        ),
      ],
      child: FirebasePhoneAuthProvider(
        child: GetMaterialApp(
          // navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.cupertino,
          popGesture: Get.isPopGestureEnable,
          theme: ThemeData(
              backgroundColor: const Color(0xffe7f0fd),
              primarySwatch: Colors.orange,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          themeMode: ThemeMode.system,
          // getPages: AppPages.pages,
          // initialRoute: AppRoutes.main,

          title: "aisect",
          routes: AppPages.routes,
          builder: EasyLoading.init(),
          home: FutureBuilder<Object>(
              future: _initialization,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  // startNotification();
                  return SplashScreen();
                }
                return Constant.circle();
              }),
        ),
      ),
    );
  }
}

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: const Color(0xffe7f0fd),
    primaryColor: Colors.deepOrange,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    primaryColor: Colors.deepOrange,
  );
}
