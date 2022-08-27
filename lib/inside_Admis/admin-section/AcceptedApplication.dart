// import 'dart:math';
// import 'package:aisect_custom/widget/customDialog.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// class AcceptedUserInfo extends StatefulWidget {
//   @override
//   _AcceptedUserInfoState createState() => _AcceptedUserInfoState();
// }

// class _AcceptedUserInfoState extends State<AcceptedUserInfo> {
//   final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
//       .collection('Accepted_Admission_Application')
//       .snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Accepted List")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _usersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: Column(
//               children: [Text("Loading"), SpinKitFadingCube()],
//             ));
//           }

//           return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String id = snapshot.data!.docs[index].id;
//                 // String id1 = snapshot.data!.docs[index].get({'full_name'});

//                 return GestureDetector(
//                     child: ListTile(
//                       title: Text(
//                         "${id}",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     onTap: () => Get.to(() => AcceptedList(
//                           id: id,
//                         )));
//                 // Navigator.pushReplacement(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => AcceptedList(
//                 //               id: id,
//                 //             ))),
//                 // );
//               });
//           // ListView(
//           //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           //     Map<String, dynamic> data =
//           //         document.data()! as Map<String, dynamic>;
//           //     return ListTile(
//           //       title: InkWell(
//           //           onTap: () => Navigator.pushReplacement(context,
//           //               MaterialPageRoute(builder: (context) => FuturePage())),
//           //           child: Text(document.id)),
//           //       // subtitle: Text(data['Selected Discipline']),
//           //     );
//           //   }).toList(),
//           // );
//         },
//       ),
//     );
//   }
// }

// class AcceptedList extends StatelessWidget {
//   final String id;
//   AcceptedList({
//     Key? key,
//     required this.id,
//   }) : super(key: key);

//   /// Function that will return a
//   /// "string" after some time
//   /// To demonstrate network call
//   /// delay of [2 seconds] is used
//   ///
//   /// This function will behave as an
//   /// asynchronous function

//   Map<String, dynamic>? storedata;
//   var token;

//   final CollectionReference _usersCollectionReference =
//       FirebaseFirestore.instance.collection("New_Admission_Application");
//   var data;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Application Detail"),
//         ),
//         body: FutureBuilder<DocumentSnapshot>(
//             future: _usersCollectionReference.doc("$id").get(),
//             builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text("Something went wrong"),
//                 );
//               }

//               if (snapshot.hasData && !snapshot.data!.exists) {
//                 return Center(
//                   child: Text("Enjoy! :) you have no work for now"),
//                 );
//               }

//               if (snapshot.connectionState == ConnectionState.done) {
//                 Map<String, dynamic> data =
//                     snapshot.data!.data() as Map<String, dynamic>;
//                 storedata = data;

//                 return SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       //? give me more data

//                       showDataFromDB(data, context),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // ElevatedButton(
//                           //     style: ElevatedButton.styleFrom(
//                           //         primary: Colors.red,
//                           //         textStyle: TextStyle(fontSize: 35)),
//                           //     onPressed: () {},
//                           //     child: Text("Reject")),
//                           SizedBox(width: 30),
//                           ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.deepOrangeAccent,
//                                   textStyle: TextStyle(fontSize: 35)),
//                               onPressed: () {
//                                 //
//                               },
//                               child: Text("Accept")),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                           onPressed: () {
//                             Get.to(() => AcceptedUserInfo());
//                             // Navigator.pushReplacement(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => AcceptedUserInfo()));
//                           },
//                           child: Text("good!"))
//                     ],
//                   ),
//                 );
//                 // return Text("Full Name: ${data['full name']}");
//               }

//               return Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SpinKitHourGlass(color: Colors.blueAccent),
//                   Text("loading"),
//                 ],
//               ));
//             }
//             // Future that needs to be resolved
//             // inorder to display something on the Canvas

//             ),
//       ),
//     );
//   }

//   Container showDataFromDB(Map<String, dynamic> data, context) {
//     return Container(
//       // height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             loadedtextBox("NAME : ", "${data["full_name"]}"),
//             loadedtextBox("D.O.B : ", "${data["D_O_B"]}"),
//             loadedtextBox("Father\'s Name : ", "${data["father_Name"]}"),
//             loadedtextBox("Mother\'s Name: ", "${data["mother_Name"]}"),
//             loadedtextBox("Email : ", "${data["Email"]}"),
//             loadedtextBox("Phone : ", "${data["Phone_No"]}"),
//             loadedtextBox("aadhar no: ", "${data["Aadhar_No"]}"),
//             loadedtextBox("Course : ", "${data["Selected Course"]}"),
//             loadedtextBox("Discipline : ", "${data["Selected Discipline"]}"),
//             loadedtextBox("Vill : ", "${data["Vill"]}"),
//             loadedtextBox("P.O. : ", "${data["Post Office"]}"),
//             loadedtextBox("District : ", "${data["District"]}"),
//             loadedtextBox("State : ", "${data["State"]}"),
//             loadedtextBox("Pincode : ", "${data["Pincode"]}"),
//             loadedtextBox("Exam Roll : ", "${data["Exam_Roll_NO"]}"),
//             loadedtextBox("Last Exam : ", "${data["Last_Exam_Qualified"]}"),
//             loadedtextBox("Percentage : ", "${data["Percent"]}"),
//             loadedtextBox("Board : ", "${data["board"]}"),
//           ],
//         ),
//       ),
//     );
//   }

//   //================================================================
//   //If application accepted
//   //================================================================
//   final CollectionReference admissionApplication =
//       FirebaseFirestore.instance.collection("Accepted_Admission_Application");

//   Future<void> addAdmissionApplication() {
//     // Call the user's CollectionReference to add a new user
//     return admissionApplication.doc("$token")
//         // .doc(
//         //     "${storedata!["full_name"]} : applied for ${storedata!["selecteddiscipline"]}")
//         .set({
//       'full_name': storedata!["full_name"],
//       'father_Name': storedata!["father_Name"],
//       'mother_Name': storedata!["mother_Name"],
//       'Email': storedata!["Email"],
//       'Aadhar_No': storedata!["Aadhar_No"],
//       'Phone_No': storedata!["Phone_No"],
//       'Vil': storedata!["Vill"],
//       'Post Office': storedata!["Post Office"],
//       'District': storedata!["District"],
//       'State': storedata!["State"],
//       'Pincode': storedata!["Pincode"],
//       'Last_Exam_Qualified': storedata!["Last_Exam_Qualified"],
//       'Percent': storedata!["Percent"],
//       'board': storedata!["board"],
//       // 'Board_Roll': _boardRoll1,
//       'Exam_Roll_NO': storedata!["Exam_Roll_NO"],
//       // 'board_Roll_Code': _boar',
//       'D_O_B': storedata!["D_O_B"],
//       'Selected Course': storedata!["selectedCourse"],
//       'Selected Discipline': storedata!["selecteddiscipline"],
//       // Stokes and Sons
//     }).catchError((error) => Fluttertoast.showToast(msg: "$error"));
//   }

//   //----------------------------------------------------
//   //! TextBox
//   Padding loadedtextBox(String prefix, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: SizedBox(
//         height: 80,
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Container(
//             height: 70,
//             child: Padding(
//               padding: const EdgeInsets.all(21.0),
//               child: Text(
//                 "${prefix}  ${text}",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//                 gradient: LinearGradient(
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                     colors: [Colors.white, Color.fromRGBO(0, 41, 70, 150)])),

//             // ),
//           ),
//         ),
//       ),
//     );
//   }
//   //=====================
//   //==Generate token For accepted application

// }

// ///===================================================================
// ///class
// ///
