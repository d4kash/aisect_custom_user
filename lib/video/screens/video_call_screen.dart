import 'package:aisect_custom/video/resources/auth_methods.dart';
import 'package:aisect_custom/video/resources/jitsi_meet_methods.dart';
import 'package:aisect_custom/video/widgets/meeting_option.dart';
import 'package:aisect_custom/widget/appBar.dart';
import 'package:aisect_custom/widget/containerWidget.dart';
import 'package:aisect_custom/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:jitsi_meet_fix/jitsi_meet.dart';

import '../../services/constant.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AuthMethods _authMethods = AuthMethods();
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    meetingIdController = TextEditingController();
    nameController = TextEditingController(
      text: _authMethods.user.displayName,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    meetingIdController.dispose();
    nameController.dispose();
    JitsiMeet.removeAllListeners();
  }

  _joinMeeting() {
    _jitsiMeetMethods.createMeeting(
      roomName: meetingIdController.text,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      username: nameController.text,
    );
  }

  FormTextCont textBox = FormTextCont();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBarScreen(
        title: 'Join a Meeting',
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              textBox.formText(
                  meetingIdController,
                  const Icon(Icons.person, color: Colors.black),
                  "Room ID",
                  [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                  RequiredValidator(errorText: "required"),
                  30,
                  TextInputType.name,
                  Colors.amber[300]),
              textBox.formText(
                  nameController,
                  const Icon(Icons.person, color: Colors.black),
                  "Name",
                  [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+|\s'))],
                  RequiredValidator(errorText: "required"),
                  30,
                  TextInputType.name,
                  Colors.amber[300]),
              // SizedBox(
              //   height: 60,
              //   child: TextField(
              //     controller: meetingIdController,
              //     maxLines: 1,
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     decoration: const InputDecoration(
              //       // fillColor: Constant.backgroundColor,
              //       // filled: true,
              //       border: InputBorder.none,
              //       hintText: 'Room ID',
              //       contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 60,
              //   child: TextField(
              //     controller: nameController,
              //     maxLines: 1,
              //     textAlign: TextAlign.center,
              //     keyboardType: TextInputType.number,
              //     decoration: const InputDecoration(
              //       // fillColor: secondaryBackgroundColor,
              //       // filled: true,
              //       border: InputBorder.none,
              //       hintText: 'Name',
              //       contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              CustomButtonNew(
                text: "Join",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    _joinMeeting;
                  }
                  // if (meetingIdController.text != "") {
                  else {
                    print("check fails");
                    Constant.showSnackBar(
                        context, "* All Fields are required !");
                  }
                },
              ),
              const SizedBox(height: 20),
              MeetingOption(
                text: 'Mute Audio',
                isMute: isAudioMuted,
                onChange: onAudioMuted,
              ),
              MeetingOption(
                text: 'Turn Off My Video',
                isMute: isVideoMuted,
                onChange: onVideoMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onAudioMuted(bool val) {
    setState(() {
      isAudioMuted = val;
    });
  }

  onVideoMuted(bool val) {
    setState(() {
      isVideoMuted = val;
    });
  }
}
