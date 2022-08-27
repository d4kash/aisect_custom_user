import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/video/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder(
        stream: FirestoreMethods().meetingsHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Constant.circle(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                'Room Name: ${(snapshot.data! as dynamic).docs[index]['meetingName']}',
              ),
              subtitle: Text(
                'Joined on ${DateFormat.yMMMd().format((snapshot.data! as dynamic).docs[index]['createdAt'].toDate())}',
              ),
            ),
          );
        },
      );
    } catch (e) {
      return Center(child: Text("Login First"));
    }
  }
}
