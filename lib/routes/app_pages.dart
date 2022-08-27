import 'package:aisect_custom/Authenticate/Autheticate.dart';
import 'package:aisect_custom/Exam_panel/Exams.dart';
import 'package:aisect_custom/Exam_panel/TimeTable.dart';
import 'package:aisect_custom/Exam_panel/examForm.dart';
import 'package:aisect_custom/Exam_panel/idForExam.dart';
import 'package:aisect_custom/Home/CompleteProfile.dart';
import 'package:aisect_custom/Home/buttomnav/custombottomnav.dart';
import 'package:aisect_custom/Result-Section/Results.dart';
import 'package:aisect_custom/Result-Section/getResult.dart';
import 'package:aisect_custom/Result-Section/revaluation.dart';
import 'package:aisect_custom/Splash/SplashScreen.dart';
import 'package:aisect_custom/drawer/page/Logout.dart';
import 'package:aisect_custom/drawer/page/profile.dart';

import 'package:aisect_custom/google/widget/sign_up_widget.dart';
import 'package:aisect_custom/inside_Admis/Admission.dart';
import 'package:aisect_custom/inside_Admis/Apply.dart';
import 'package:aisect_custom/inside_Admis/Enquiry.dart';
import 'package:aisect_custom/inside_Admis/course.dart';
import 'package:aisect_custom/inside_Admis/status.dart';
import 'package:aisect_custom/inside_resources/Resources.dart';
import 'package:aisect_custom/inside_resources/grievance_form.dart';
import 'package:aisect_custom/inside_resources/study_notes.dart';
import 'package:aisect_custom/inside_resources/syllabus.dart';
import 'package:aisect_custom/notice/notice-admin/notice_admin.dart';
import 'package:aisect_custom/notice/noticeHome.dart';
import 'package:aisect_custom/notice/notice_section.dart';

import 'package:aisect_custom/onboarding/screens/onboard/onboard.dart';
import 'package:aisect_custom/video/screens/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  // static final List<GetPage> pages = [
  //   GetPage(
  //     name: AppRoutes.main,
  //     page: () => SplashScreen(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.home,
  //     page: () => HomePageNav(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.profile,
  //     page: () => Profile(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.logout,
  //     page: () => LogoutPage(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.notice,
  //     page: () => NoticeHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.admissionHome,
  //     page: () => AdmissionHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.admissionApply,
  //     page: () => ApplyForAdmission(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.enquiry,
  //     page: () => EnquiryForm(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.CourseFee,
  //     page: () => Fee(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.status,
  //     page: () => ApplicationStatus(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.examHome,
  //     page: () => ExamHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.ExamApply,
  //     page: () => ExamFormNew(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.TimeTable,
  //     page: () => TimeTable(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.admitCard,
  //     page: () => IdForOnlineExam(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.ResultHome,
  //     page: () => ResultHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.getResult,
  //     page: () => GetResult(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.revaluation,
  //     page: () => Revaluation(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.ResourceHome,
  //     page: () => ResourcesHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.syllabus,
  //     page: () => Syllabus(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.complaintForm,
  //     page: () => GrievanceForm(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.notes,
  //     page: () => StudyNotes(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.noticeHome,
  //     page: () => NoticeStudent(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.splashScreen,
  //     page: () => SplashScreen(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.completeProfile,
  //     page: () => CompleteProfile(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.signup,
  //     page: () => SignUpWidget(),
  //     // binding: HomeBinding(),
  //   ),
  //   // GetPage(
  //   //   name: AppRoutes.noticeStudent,
  //   //   page: () => NoticeStudent(),
  //   //   // binding: HomeBinding(),
  //   // ),
  //   GetPage(
  //     name: AppRoutes.onboard,
  //     page: () => Onboard(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.noticeAdmin,
  //     page: () => NoticeAdminHome(),
  //     // binding: HomeBinding(),
  //   ),
  //   GetPage(
  //     name: AppRoutes.gmailLogin,
  //     page: () => Authenticate(),
  //     // binding: HomeBinding(),
  //   ),
  // ];
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    "/video-call": (BuildContext context) => const VideoCallScreen(),
    // AppRoutes.main: (BuildContext context) => SplashScreen(),
    AppRoutes.home: (BuildContext context) => HomePageNav(),
    AppRoutes.profile: (BuildContext context) => Profile(),
    AppRoutes.logout: (BuildContext context) => LogoutPage(),
    AppRoutes.admissionHome: (BuildContext context) => AdmissionHome(),
    AppRoutes.admissionApply: (BuildContext context) => ApplyForAdmission(),
    AppRoutes.enquiry: (BuildContext context) => EnquiryForm(),
    AppRoutes.CourseFee: (BuildContext context) => Fee(),
    AppRoutes.status: (BuildContext context) => ApplicationStatus(),
    AppRoutes.examHome: (BuildContext context) => ExamHome(),
    AppRoutes.ExamApply: (BuildContext context) => ExamFormNew(),
    AppRoutes.TimeTable: (BuildContext context) => TimeTable(),
    AppRoutes.admitCard: (BuildContext context) => IdForOnlineExam(),
    AppRoutes.ResultHome: (BuildContext context) => ResultHome(),
    AppRoutes.getResult: (BuildContext context) => GetResult(),
    AppRoutes.revaluation: (BuildContext context) => Revaluation(),
    AppRoutes.ResourceHome: (BuildContext context) => ResourcesHome(),
    AppRoutes.syllabus: (BuildContext context) => Syllabus(),
    AppRoutes.complaintForm: (BuildContext context) => GrievanceForm(),
    AppRoutes.notes: (BuildContext context) => StudyNotes(),
    AppRoutes.splashScreen: (BuildContext context) => SplashScreen(),
    AppRoutes.completeProfile: (BuildContext context) => CompleteProfile(),
    AppRoutes.signup: (BuildContext context) => SignUpWidget(),
    AppRoutes.onboard: (BuildContext context) => Onboard(),
    AppRoutes.gmailLogin: (BuildContext context) => Authenticate(),
    AppRoutes.noticeStud: (BuildContext context) => NoticeStudent(),
  };
}
