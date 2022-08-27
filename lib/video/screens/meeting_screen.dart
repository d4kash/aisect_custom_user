import 'dart:math';

import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/video/resources/jitsi_meet_methods.dart';
import 'package:aisect_custom/video/widgets/home_meeting_button.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:flutter/material.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({Key? key}) : super(key: key);

  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();
    _jitsiMeetMethods.createMeeting(
        roomName: roomName, isAudioMuted: true, isVideoMuted: true);
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(height / 45),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeMeetingButton(
                onPressed: createNewMeeting,
                text: 'New Meeting',
                icon: Icons.videocam,
              ),
              HomeMeetingButton(
                onPressed: () => joinMeeting(context),
                text: 'Join Meeting',
                icon: Icons.add_box_rounded,
              ),
              HomeMeetingButton(
                onPressed: () {
                  Constant.showSnackBar(context, "Work in progress ");
                },
                text: 'Schedule',
                icon: Icons.calendar_today,
              ),
              HomeMeetingButton(
                onPressed: () {
                  Constant.showSnackBar(context, "Work in progress ");
                },
                text: 'Share Screen',
                icon: Icons.arrow_upward_rounded,
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Create/Join Meetings with just a click!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
