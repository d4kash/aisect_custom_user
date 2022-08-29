// ignore_for_file: require_trailing_commas
import 'dart:async';
import 'dart:io';
import 'package:aisect_custom/Network/connectivity_provider.dart';
import 'package:aisect_custom/Network/no_internet.dart';
import 'package:aisect_custom/drawer/page/customExcep.dart';
import 'package:aisect_custom/drawer/page/error_page.dart';
import 'package:aisect_custom/drawer/page/profile_modal.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:aisect_custom/services/FirebaseStorage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../firebase_helper/FirebaseConstants.dart';
import '../../../widget/containerWidget.dart';

// import '';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController profilename = TextEditingController();
  TextEditingController profilphone = TextEditingController();
  final profileEmail = TextEditingController();
  TextEditingController profilCourse = TextEditingController();
  TextEditingController profileDisci = TextEditingController();

  Timer? _timer;
  RxString uid = "no user".obs;
  String? task2;
  var task =
      "https://firebasestorage.googleapis.com/v0/b/aisect-42fe7.appspot.com/o/StudentProfileImg%2FEEFEZxEPLoTm0byR3wJZVIyCIJ62%2Fimage_picker9094997287726926097.gif?alt=media&token=6c9e4b36-a9d9-4acb-b2d9-0bda4c66bb3c"
          .obs;
  final formGlobalKey = GlobalKey<FormState>();
  RxBool notLoggedIn = false.obs;
  double progress = 0;
  UploadTask? upload;
  String? percentage;
  // final RegExp email = new RegExp(
  //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  void initState() {
    // TODO: implement initState
    initializeUser();

    super.initState();
  }

  Future initializeUser() async {
    try {
      var _auth = await FirebaseAuth.instance;

      if (_auth.currentUser != null) {
        uid.value = await _auth.currentUser!.uid;
        debugPrint(uid.string);
        task2 = FirebaseAuth.instance.currentUser!.photoURL;
        // retrieveData();
      } else {
        notLoggedIn.value = true;
      }
    } on FirebaseAuthException catch (authError) {
      throw CustomAuthException(authError.code, authError.message!);
    } catch (e) {
      throw CustomException(errorMessage: "Unknown Error");
    }
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    // uid.value = user.toString();

    print(" initilalized user from profile: $uid");
  }

  // var modalData;
  // Future retrieveData() async {
  //   try {
  //     var collection =
  //         FirebaseFirestore.instance.collection('New_Admission_Request');
  //     var docSnapshot = await collection.doc(constuid).get();
  //     if (docSnapshot.exists) {
  //       Map<String, dynamic>? data = docSnapshot.data();
  //       modalData = ProfileModal.fromMap(data!);
  //       // Constant.roll = data["ExamRoll"];
  //       // Constant.batchfromDB = data["batch"];
  //       // Constant.semFromDB = data["semester"];
  //       // Constant.faculty = data["Faculty"];
  //       // Constant.roll = modalData.ExamRoll;
  //       // Constant.batchfromDB = modalData.batch;
  //       // Constant.semFromDB = modalData.semester;
  //       // Constant.faculty = modalData.Faculty;

  //       setState(() {});
  //       // <-- The value you want to retrieve.
  //       // Call setState if needed.

  //     }
  //     // print(Constant.roll);
  //     // print(Constant.batchfromDB);
  //     // print(Constant.semFromDB);
  //     // print(Constant.faculty);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("New_Admission_Request");

// Add profile Image
  Future addProfileData(String url) async {
    try {
      _usersCollectionReference
          .doc(Constant.batchfromDB)
          .collection(Constant.semFromDB)
          .doc(Constant.faculty)
          .collection('StudentRollList')
          .doc(Constant.roll)
          .update({
        'ProfileUrl': url,
      });
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return Consumer<ConnectivityProvider>(
        builder: (consumerContext, model, child) {
      if (model.isOnline) {
        return model.isOnline
            ? Obx(() => notLoggedIn.isFalse
                ? Scaffold(
                    // This trailing comma makes auto-formatting nicer for build methods.
                    body: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('New_Admission_Request')
                          .doc(constuid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Onerror(context, "Something Went Wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Onerror(context, "Fetching Data");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          var profileData = ProfileModal.fromMap(data);
                          return profileView(
                              context, profileData, profileData.ProfileUrl);
                          // return Text("Full Name: ${data['full name']}");
                        }

                        return Constant.circle();
                      },
                    ),
                  )
                : ErrorPage(message: "Login First"))
            : NoInternet();
      }

      return Constant.circle();
    });
  }

  var file = File('').obs;
  ImagePicker image = ImagePicker();
  // File? file;
  Future getImage() async {
    try {
      var img = await image.pickImage(source: ImageSource.gallery);
      // setState(() {
      file.value = File(img!.path);
      // });

      await uploadImageToFirebase();
      await EasyLoading.showSuccess('Success!',
          duration: const Duration(seconds: 1));
    } catch (e) {
      print("error caught: $e");
    }
  }

//! upload to cloud firestore________________________
  Future uploadImageToFirebase() async {
    try {
      _timer?.cancel();

      await EasyLoading.show(status: 'uploading...');
      // await Future.delayed(const Duration(milliseconds: 800));

      if (file == null) return;
      String fileName = basename(file.value.path);
      final destination = 'StudentProfileImg/$uid/$fileName';
      // upload = await MyFirebaseStorage.uploadPdf(destination, file.value);
      // final ref = firebase_storage.Reference.instance.ref(destination);
      upload = await MyFirebaseStorage.uploadPdf(destination, file.value);
      var task1 = await (await upload!).ref.getDownloadURL();
      // setState(() {
      task.value = task1;

      setState(() {});
      await addProfileData(task.value);
      EasyLoading.dismiss();
      // print("$task");
    } catch (e) {
      print("error caught: $e");
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            progress = snap.bytesTransferred / snap.totalBytes;
            percentage = (progress * 100).toStringAsFixed(2);

            // return Center(
            //     child:Column(children: [

            //   ],));
            return Text(
              '{$percentage % don\'t touch me}',
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return Container(
              color: Colors.red,
            );
          }
        },
      );
  Widget Onerror(context, String error) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f0fd),
      appBar: AppBarScreen(title: "Profile"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24, width: 24),
          Constant.circle(),
          Text(error),
        ],
      ),
    );
  }

  Widget profileView(
    context,
    ProfileModal modalData,
    img,
  ) {
    FormTextCont cons = FormTextCont();
    return Scaffold(
        backgroundColor: const Color(0xffe7f0fd),
        appBar: AppBarScreen(
          title: 'Profile',
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: Constant.height / 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Stack(
                children: <Widget>[
                  OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedColor: const Color(0xffe7f0fd),
                    openColor: const Color(0xffe7f0fd),
                    middleColor: const Color(0xffe7f0fd),
                    closedElevation: 0.0,
                    openElevation: 4.0,
                    transitionDuration: const Duration(milliseconds: 800),
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return circleAvatar(img);
                    },
                    openBuilder: (BuildContext context,
                        void Function({Object? returnValue}) action) {
                      return ViewProfile(imgLink: img);
                    },
                  ),
                  Positioned(
                      bottom: 1,
                      right: 1,
                      child: InkWell(
                        onTap: () async {
                          await getImage();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      )),
                ],
              ),
            ),
            // Container(
            //   color: Colors.red,
            // ),
            Expanded(
              child: Container(
                // height: height / 10,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 158, 241, 201),
                          Color.fromARGB(255, 133, 189, 228)
                        ])),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Constant.height / 50,
                                ),
                                loadedtextBox("${modalData.full_name}", "Name"),
                                SizedBox(
                                  height: Constant.height / 50,
                                ),
                                loadedtextBox("${modalData.Phone_No}", "Phone"),
                                SizedBox(
                                  height: Constant.height / 50,
                                ),
                                loadedtextBox("${modalData.email}", "Email"),
                                SizedBox(
                                  height: Constant.height / 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }

  CircleAvatar circleAvatar(img) {
    return CircleAvatar(
      radius: 70,
      child: ClipOval(
        child: CachedNetworkImage(
          height: 150,
          width: 150,
          fit: BoxFit.cover,
          imageUrl: img,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        // image: file == null
        //     ? NetworkImage('$img')
        //     : FileImage(File(file!.path)) as ImageProvider,
        // height: 150,
        // width: 150,
        // fit: BoxFit.cover,
      ),
      // child: Image.file(
      // file == null
    );
  }

  Widget loadedtextBox(String text, String prefix) {
    return FittedBox(
      fit: BoxFit.contain,
      // height: Constant.height / 25,
      child: Text(
        "$prefix : $text",
        style: TextStyle(
          fontSize: Constant.height / 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ViewProfile extends StatelessWidget {
  final String imgLink;
  const ViewProfile({Key? key, required this.imgLink}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    debugPrint(FirebaseAuth.instance.currentUser!.phoneNumber);
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imgLink,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
