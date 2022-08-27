import 'dart:math';

import 'package:aisect_custom/google/widget/sign_up_widget.dart';
import 'package:aisect_custom/onboarding/components/fading_sliding_widget.dart';
import 'package:aisect_custom/onboarding/model/onboard_page_item.dart';
import 'package:aisect_custom/onboarding/screens/onboard/onboard_page.dart';
import 'package:aisect_custom/onboarding/screens/onboard/welcome_page.dart';
import 'package:aisect_custom/services/LocalData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workmanager/workmanager.dart';

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with SingleTickerProviderStateMixin {
  List<OnboardPageItem> onboardPageItems = [
    OnboardPageItem(
      lottieAsset: 'assets/animations/video_call.json',
      text: 'You Don\'t have to switch app for joining meetings',
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/work_from_home.json',
      text: 'Do all university related work, with few \nclicks',
      animationDuration: const Duration(milliseconds: 1100),
    ),
    OnboardPageItem(
      lottieAsset: 'assets/animations/group_working.json',
      text:
          'Now, this enables you to see and \ndownload your Results & Admit Cards,\nNotes,Syllabus ',
    ),
  ];

  late PageController _pageController;

  List<Widget> onboardItems = [];
  late double _activeIndex;
  bool onboardPage = false;
  late AnimationController _animationController;
  RxBool isCompleted = false.obs;

  @override
  void initState() {
    initializePages(); //initialize pages to be shown
    _pageController = PageController();
    _pageController.addListener(() {
      _activeIndex = _pageController.page!;
      print("Active Index: $_activeIndex");
      if (_activeIndex >= 0.5 && onboardPage == false) {
        setState(() {
          onboardPage = true;
        });
      } else if (_activeIndex < 0.5) {
        setState(() {
          onboardPage = false;
        });
      }
      if (_activeIndex >= 3) {
        isCompleted.value = true;
      } else {
        isCompleted.value = false;
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    super.initState();
  }

  initializePages() {
    onboardItems.add(WelcomePage());
    LocalData.saveFirstTime(true); // welcome page
    onboardPageItems.forEach((onboardPageItem) {
      //adding onboard pages
      onboardItems.add(OnboardPage(
        onboardPageItem: onboardPageItem,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: onboardItems,
            ),
          ),
          Positioned(
            bottom: height * 0.15,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardItems.length,
              effect: WormEffect(
                dotWidth: width * 0.03,
                dotHeight: width * 0.03,
                dotColor: onboardPage
                    ? const Color(0x11000000)
                    : const Color(0x566FFFFFF),
                activeDotColor: onboardPage
                    ? const Color(0xFF9544d0)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Obx(() => isCompleted.isTrue
              ? Positioned(
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () async {
                      // startNotification();
                      LocalData.saveFirstTime(true);
                      Get.off(() => SignUpWidget());
                    },
                    child: FadingSlidingWidget(
                      animationController: _animationController,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        alignment: Alignment.center,
                        width: width * 0.8,
                        height: height * 0.075,
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: onboardPage
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF220555),
                            fontSize: width * 0.05,
                            fontFamily: 'ProductSans',
                          ),
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.1),
                          ),
                          gradient: LinearGradient(
                            colors: onboardPage
                                ? [
                                    const Color(0xFF8200FF),
                                    const Color(0xFFFF3264),
                                  ]
                                : [
                                    const Color(0xFFFFFFFF),
                                    const Color(0xFFFFFFFF),
                                  ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()),
        ],
      ),
    );
  }

  startNotification() async {
    var random = Random();
    print('hitted');
    await Workmanager().registerPeriodicTask(
      "fetch${random.nextInt(1000)}",
      "fetchBackground",
      frequency: Duration(minutes: 15),
      initialDelay: Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
    print('successed');
  }
}
