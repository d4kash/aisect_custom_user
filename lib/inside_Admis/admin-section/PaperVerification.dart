import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../services/constant.dart';
import '../../widget/appBar.dart';
import 'PaperVerificationDetailPage.dart';

class AcceptedCandidate extends StatefulWidget {
  @override
  _AcceptedCandidateState createState() => _AcceptedCandidateState();
}

class _AcceptedCandidateState extends State<AcceptedCandidate> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Accepted_Admission_Application')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBarScreen(title: "Accepted List"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
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
                      onTap: () => Get.to(() => PaperVerificationDetail(
                            id: id,
                          ))),
                );
              });
        },
      ),
    );
  }
}

//!==============================================

