import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../services/constant.dart';
import '../../widget/appBar.dart';
import 'AppliedDetails.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('New_Admission_Application')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBarScreen(title: "Application List"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return ListView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String id = snapshot.data!.docs[index].id;
                // String id1 = snapshot.data!.docs[index].get({'full_name'});

                return Card(
                  child: GestureDetector(
                      child: ListTile(
                        title: Text(
                          "${id}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      onTap: () => Get.to(
                            () => IdDetailsPage(
                              id: id,
                            ),
                          )),
                );
              });
        },
      ),
    );
  }
}

//!==============================================

