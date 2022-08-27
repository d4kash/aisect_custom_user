import 'dart:convert';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aisect_custom/GetController/theme_controller.dart';
import 'package:aisect_custom/model/jsontodart.dart';
import 'package:aisect_custom/services/constant.dart';

class Fee extends StatefulWidget {
  const Fee({Key? key}) : super(key: key);

  @override
  _FeeState createState() => _FeeState();
}

class _FeeState extends State<Fee> {
  var onChanged = "0".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(
        title: 'Course & Fee',
      ),
      body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("assets/files/courses.json"),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data != null &&
                snapshot.connectionState == ConnectionState.done) {
              var myDataFromJson = json.decode(snapshot.data.toString());
              // var data = myDataFromJson["course"];
              return CourseFe(myDataFromJson: myDataFromJson);
            } else {
              return const Center(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
          }),
    );
  }
}

class CourseFe extends StatelessWidget {
  const CourseFe({Key? key, required this.myDataFromJson}) : super(key: key);

  final myDataFromJson;
  final List<List<Color>> color = const [
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
    [Color(0xffff9a9e), Color(0xfffad0c4)],
    [Color(0xC0919243), Color(0xff96e6a1)],
    [Color(0xff2af598), Color(0xff009efd)],
    [Color(0xffaccbee), Color(0xFFC3D5EE)],
    [Color(0xFF8E97C2), Color(0xFFB064CE)],
  ];
  @override
  Widget build(BuildContext context) {
    RxBool _isClicked = false.obs;
    return GetBuilder<RadioController>(
        init: RadioController(),
        initState: (_) {},
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: color[index],
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          value: index,
                          groupValue: controller.value.value,
                          onChanged: (ind) {
                            controller.onItemSelect(ind as int, myDataFromJson);
                            _isClicked.value = true;
                            controller.update();
                            // print("${controller.value.value} on click");
                            // print(
                            //     "${myDataFromJson["course"][controller.value.value]} on click");
                          },
                          title: Text(
                            myDataFromJson["course"][index],
                            style: TextStyle(
                                fontSize: Constant.height / 45,
                                fontWeight: FontWeight.w600),
                          ),
                          activeColor: const Color.fromARGB(255, 252, 129, 92),
                        ),
                      );
                    },
                    childCount: myDataFromJson["course"].length,
                  ),
                ),
                Obx(() => SliverPadding(
                      padding: const EdgeInsets.only(top: 28),
                      sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              try {
                                return Container(
                                  alignment: Alignment.center,
                                  height: Constant.height / 40,
                                  width: Constant.width / 2,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: color[index],
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: RadioListTile(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    value: index,
                                    groupValue: controller.sub.value,
                                    onChanged: (ind) {
                                      controller.onSubSelect(
                                          ind as int, myDataFromJson);

                                      var model = Model.fromMap(myDataFromJson[
                                          controller.facultydata2.value]);
                                      showDialog(
                                        // barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                          title: model.department,
                                          course: model.course,
                                          csn: model.csn,
                                          duration: model.duration,
                                          eligiblity: model.eligiblity,
                                          fee: model.fee,
                                          color: color,
                                          index: index,
                                        ),
                                      );
                                      controller.value.value = 3;
                                      controller.sub.value = 30;

                                      // print(model.department);
                                      // print(model.course);
                                      print(model.fee);
                                      // print(model.duration);
                                      // print(model.eligiblity);
                                      // print(myDataFromJson[
                                      //         controller.coursedata.value]
                                      //     .length);
                                    },
                                    title: Text(
                                      myDataFromJson[
                                          controller.coursedata.value][index],
                                      style: TextStyle(
                                          fontSize: Constant.height / 50,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    activeColor:
                                        const Color.fromARGB(255, 252, 129, 92),
                                  ),
                                );
                              } catch (e) {
                                print("Caught Error: $e");
                                return Column(
                                  children: [Container()],
                                );
                              }
                            },
                            childCount:
                                myDataFromJson[controller.coursedata.value]
                                    .length,
                          )),
                    )),
              ],
            ),
          );
        });
  }
}

class CustomDialog extends StatelessWidget {
  final String title, course, csn, duration, eligiblity, fee;
  final List<List<Color>> color;
  final int index;

  const CustomDialog({
    Key? key,
    required this.color,
    required this.index,
    required this.title,
    required this.course,
    required this.csn,
    required this.duration,
    required this.eligiblity,
    required this.fee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      // backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            // top: 66.0 + 16.0 * 12,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: const EdgeInsets.only(top: 30.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: color[index],
            ), //Colors.black.withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              SizedBox(height: Constant.height / 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  course,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: Constant.height / 40,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: Constant.height / 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  csn,
                  style: TextStyle(
                    fontSize: Constant.height / 40,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: Constant.height / 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  duration,
                  style: TextStyle(
                    fontSize: Constant.height / 40,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: Constant.height / 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  eligiblity,
                  style: TextStyle(
                    fontSize: Constant.height / 40,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: Constant.height / 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$fee/sem",
                  style: TextStyle(
                    fontSize: Constant.height / 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: const Text(
                    "okay",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            left: 16.0,
            right: 16.0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Constant.height / 40,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}
