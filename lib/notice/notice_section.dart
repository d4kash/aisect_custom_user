import 'package:aisect_custom/drawer/page/error_page.dart';
import 'package:aisect_custom/drawer/page/profile_modal.dart';
import 'package:aisect_custom/firebase_helper/FirebaseConstants.dart';
import 'package:aisect_custom/model/list_notice.dart';
import 'package:aisect_custom/notification/notification_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../services/constant.dart';
import '../../widget/appBar.dart';

class NoticeStudent extends StatefulWidget {
  @override
  _NoticeStudentState createState() => _NoticeStudentState();
}

class _NoticeStudentState extends State<NoticeStudent> {
  var modalData;
  final List<String> noticeItems = ["students", "All"];
  late NotificationService _notificationService;
  RxBool isStudent = true.obs;
  RxString? noticeValue = 'students'.obs;
  var noticeList;
  var everyoneNoticeList;

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    _notificationService = NotificationService();
    retrieveData();

    super.initState();
  }

  Future retrieveData() async {
    try {
      var collection =
          FirebaseFirestore.instance.collection('Raw_students_info');
      var docSnapshot = await collection.doc(constuid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        modalData = ProfileModal.fromMap(data!);

        //
        setState(() {});
      }
    } catch (e) {
      print("error ${e.toString()}");
    }
  }

  snapShot() {
    if (isStudent.isTrue) {
      return FirebaseFirestore.instance
          .collection('Add_Notice')
          .doc(noticeValue.toString())
          .collection('notice')
          .doc(modalData.batch)
          .collection(modalData.Faculty)
          .doc(modalData.semester)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Add_Notice')
          .doc('All')
          .snapshots();
    }
  }

  Stream<DocumentSnapshot> getMsg() async* {
    var snapshot = FirebaseFirestore.instance
        .collection('Add_Notice')
        .doc('All')
        .snapshots();
    Map<String, dynamic> data = snapshot as Map<String, dynamic>;
    var noticeforEveryone = NoticeForAll.fromMap(data);
  }

  @override
  Widget build(BuildContext context) {
    try {
      print(noticeValue!.string);
      return Scaffold(
        backgroundColor: Constant.backgroundColor,
        appBar: AppBarScreen(title: "Notices"),
        body: StreamBuilder<DocumentSnapshot>(
          stream: snapShot(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Loading"), Constant.circle()],
              ));
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            // print(snapshot.data!.data().runtimeType);
            if (isStudent.isTrue) {
              noticeList = NoticeList.fromMap(data);
            } else {
              everyoneNoticeList = NoticeForAll.fromMap(data);
            }
            // print(noticeList.students!.length);
            // var notices = data['students'];
            // print(notices.length);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(noticeValue.toString(),
                        style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                    InkWell(
                      child: Icon(
                        Icons.filter_alt_rounded,
                        size: 40,
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return StatefulBuilder(
                                builder: (context, setstatesd) => AlertDialog(
                                  title: Text('Select From Options'),
                                  content: Obx(
                                    () => Form(
                                      key: key,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 20, left: 16),
                                        width: width / 1.5,
                                        child: DropdownButtonHideUnderline(
                                          child:
                                              DropdownButtonFormField2<String>(
                                            isExpanded: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null) {
                                                return "Select ";
                                              }
                                              return null;
                                            },
                                            value: noticeValue.toString(),
                                            hint: const Text("Select"),
                                            items: noticeItems
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item)))
                                                .toList(),
                                            onChanged: (String? value) {
                                              if (value == "students") {
                                                // "For Students", "For Everyone"
                                                isStudent.value = true;
                                                noticeValue!.value = value!;
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              } else {
                                                debugPrint(value);
                                                isStudent.value = false;
                                                noticeValue!.value = value!;
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            iconSize: 30,
                                            iconEnabledColor: Colors.yellow,
                                            iconDisabledColor: Colors.grey,
                                            buttonHeight: 50,
                                            buttonWidth: 60,
                                            buttonPadding:
                                                const EdgeInsets.only(
                                                    left: 16, right: 30),
                                            buttonDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              color: Colors.redAccent,
                                            ),
                                            buttonElevation: 2,
                                            itemHeight: 40,
                                            itemPadding: const EdgeInsets.only(
                                                left: 16, right: 14),
                                            dropdownMaxHeight: 200,
                                            dropdownWidth: 200,
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.redAccent,
                                            ),
                                            dropdownElevation: 8,
                                            scrollbarRadius:
                                                const Radius.circular(40),
                                            scrollbarThickness: 6,
                                            scrollbarAlwaysShow: true,
                                            offset: const Offset(-20, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }));
                      },
                    ),
                  ],
                ),
                Obx(() => Container(
                    height: height / 2,
                    child: isStudent.isTrue
                        ? studentNotice(noticeList)
                        : EveryonetNotice(everyoneNoticeList))),
              ],
            );
          },
        ),
      );
    } catch (e) {
      return ErrorPage(
        message: 'Login First',
      );
    }
  }

  Widget studentNotice(NoticeList noticeList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: noticeList.students!.length != null
            ? noticeList.students!.length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Card(
                  child: GestureDetector(
                child: ListTile(
                    title: Text(
                      // "",
                      "${noticeList.students![index].read}",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      // "",
                      "${noticeList.students![index].notice_message}",
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () async {}),
              )),
            ],
          );
        });
  }

  Widget EveryonetNotice(NoticeForAll noticeForAll) {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: noticeForAll.everyone!.length != null
            ? noticeForAll.everyone!.length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Card(
                  child: GestureDetector(
                child: ListTile(
                    title: Text(
                      // "",
                      "${noticeForAll.everyone![index].notice_title}",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      // "",
                      "${noticeForAll.everyone![index].notice_message}",
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () async {}),
              )),
            ],
          );
        });
  }
}

//!==============================================

