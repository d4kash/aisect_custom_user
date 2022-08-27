// import 'dart:developer';

import 'dart:async';

import 'package:aisect_custom/google/widget/sign_up_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';

import 'package:aisect_custom/model/statusModal.dart';
import 'package:aisect_custom/services/constant.dart';
import 'package:aisect_custom/widget/appBar.dart';

import '../firebase_helper/FirebaseConstants.dart';

//****************************************************** */

const kTileHeight = 50.0;

class ApplicationStatus extends StatefulWidget {
  @override
  State<ApplicationStatus> createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends State<ApplicationStatus> {
  @override
  void initState() {
    // TODO: implement initState
    navigateUser();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isDataFound = false.obs;
  RxBool appl_accepted = false.obs;
  RxBool document_verified = false.obs;
  RxBool isRoll_assigned = false.obs;
  RxInt status_no = 0.obs;
  var statusModal;
  Future<DocumentSnapshot?> navigateUser() async {
    try {
      print("checkUserExist(); in navigate user");
      if (_auth.currentUser != null) {
        // String uid = _auth.currentUser!.uid.toString();
        final snapShot = await FirebaseFirestore.instance
            .collection("track_Admission_Application")
            .doc(constuid)
            .get();
        print(snapShot.id);
        if (snapShot.exists) {
          var data = snapShot.data();
          if (data != null) {
            isDataFound.value = true;
            statusModal = StatusModal.fromMap(data);
            status_no.value = statusModal.status;
            appl_accepted.value = statusModal.appl_accepted;
            document_verified.value = statusModal.document_verified;
            isRoll_assigned.value = statusModal.isRoll_assigned;
            print(statusModal.token);
            print(statusModal.status);
            print(statusModal.assignedRoll);
          } else {
            isDataFound.value = false;
            //no datafound
          }
        } else {
          isDataFound.value = false;
          Constant.showSnackBar(context, "No application Found");
        }
      } else {
        print("checkUserExist(); navigate in else");
        Timer(
            const Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    SignUpWidget()))); //this leads to phoneauth for students
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarScreen(title: 'Track Status'),
        body: Center(
          child: Container(
            width: height / 1.8,
            child: Obx(() => isDataFound.isTrue
                ? Card(
                    margin: EdgeInsets.all(20.0),
                    child: isDataFound.isTrue
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Application No : ${statusModal.token}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(height: 1.0),
                              Obx(() => _DeliveryProcesses(
                                    status: status_no.toInt(),
                                    processes: _data(
                                            statusModal,
                                            status_no,
                                            statusModal.appl_accepted,
                                            statusModal.document_verified,
                                            statusModal.isRoll_assigned)
                                        .deliveryProcesses,
                                    appl_accepted: statusModal.appl_accepted,
                                    doc_verified: statusModal.document_verified,
                                    isRoll_assigned:
                                        statusModal.isRoll_assigned,
                                  )),
                              Divider(height: 1.0),
                              // Padding(
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: _OnTimeBar(driver: data.driverInfo),
                              // ),
                            ],
                          )
                        : Center(
                            child: Container(
                              height: height / 5,
                              width: width / 2,
                              child: Card(child: Constant.circle()),
                            ),
                          ),
                  )
                : Center(
                    child: Container(
                    height: height / 5,
                    width: width / 2,
                    child: Card(
                      child: Text(
                        'No Application Found\nApply first',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))),
          ),
          // );
          //   },
          // ),
        ));
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  _DeliveryProcesses({
    Key? key,
    required this.processes,
    required this.status,
    required this.appl_accepted,
    required this.doc_verified,
    required this.isRoll_assigned,
  }) : super(key: key);

  final status;
  final bool appl_accepted;
  final bool doc_verified;
  final bool isRoll_assigned;
  final List<_DeliveryProcess> processes;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemCount: status + 1,
              contentsBuilder: (_, index) {
                if (processes[index].isCompleted) return null;

                return Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        processes[index].name,
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontSize: 18.0,
                            ),
                      ),
                      _InnerTimeline(messages: processes[index].messages),
                    ],
                  ),
                );
              },
              indicatorBuilder: (_, index) {
                var wid;
                if (status == 1) {
                  wid = appl_accepted == true
                      ? DotIndicator(
                          color: Color(0xff66c97f),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.0,
                          ),
                        )
                      : DotIndicator(
                          color: Color(0xff66c97f),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepOrange,
                            ),
                            child: Text("1",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 50.0)),
                          ),
                        );
                } else if (status == 2) {
                  print(doc_verified);
                  wid = doc_verified == true
                      ? DotIndicator(
                          color: Color(0xff66c97f),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.0,
                          ),
                        )
                      : DotIndicator(
                          color: Color(0xff66c97f),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepOrange,
                            ),
                            child: Text("1",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 50.0)),
                          ),
                        );
                } else {
                  wid = isRoll_assigned == true
                      ? DotIndicator(
                          color: Color(0xff66c97f),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.0,
                          ),
                        )
                      : DotIndicator(
                          color: Color(0xff66c97f),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepOrange,
                            ),
                            child: Text("1",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 50.0)),
                          ),
                        );
                }
                return wid;
              },
              connectorBuilder: (_, index, ___) {
                var wid;
                if (status == 1) {
                  wid = appl_accepted == true
                      ? SolidLineConnector(
                          color: processes[index].isapproval
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 88, 195, 49),
                        )
                      : DashedLineConnector(
                          color: processes[index].isapproval
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 88, 195, 49),
                        );
                } else if (status == 2) {
                  wid = doc_verified == true
                      ? SolidLineConnector(
                          color: processes[index].isverification
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 223, 92, 69),
                        )
                      : DashedLineConnector(
                          color: processes[index].isverification
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 88, 195, 49),
                        );
                } else if (status == 3) {
                  wid = isRoll_assigned == true
                      ? SolidLineConnector(
                          color: processes[index].isCompleted
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 223, 92, 69),
                        )
                      : DashedLineConnector(
                          color: processes[index].isCompleted
                              ? Color.fromARGB(255, 102, 201, 155)
                              : Color.fromARGB(255, 88, 195, 49),
                        );
                } else {
                  // wid = status == 4
                  //     ? DashedLineConnector(
                  //         color: processes[index].isCompleted
                  //             ? Color.fromARGB(255, 102, 201, 155)
                  //             : Color.fromARGB(255, 88, 195, 49),
                  //       )
                  //     : DashedLineConnector(
                  //         color: processes[index].isCompleted
                  //             ? Color.fromARGB(255, 102, 201, 155)
                  //             : Color.fromARGB(255, 88, 195, 49),
                  //       );
                }
                return wid;
              }),
        ),
      ),
    );
  }
}

_OrderInfo _data(var statusModal, RxInt status, bool appl_accepted,
        bool doc_verified, bool isRoll_assigned) =>
    _OrderInfo(
      status: statusModal.status,
      token: statusModal.token,
      acceptdate: statusModal.acceptDate,
      deliveryProcesses: [
        // if (status.toInt() == 1)
        statusModal.appl_accepted
            ? _DeliveryProcess.approval(statusModal)
            : _DeliveryProcess(
                'Waiting for approval',
                messages: [],
              ),
        statusModal.document_verified
            ? _DeliveryProcess.verification(statusModal)
            : _DeliveryProcess(
                'Waiting for Document verification',
                messages: [
                  _DeliveryMessage(
                    'You have to Come To University with required documents listed below :\n\n2.Original CLC, Marksheet,Migration\n3. with 2 Photograph',
                    'on this Date : ${statusModal.allotedDate}',
                  ),
                  _DeliveryMessage('1.Aadhar Card', ""),
                  _DeliveryMessage(
                    '2.Original CLC, Marksheet,Migration\n3. with 2 Photograph',
                    'on this Date ',
                  ),
                  _DeliveryMessage(
                    'Verification Date :',
                    '${statusModal.allotedDate}',
                  ),
                ],
              ),
        statusModal.isRoll_assigned
            ? _DeliveryProcess.complete(statusModal)
            : _DeliveryProcess(
                'waiting for Seat allotement',
              ),
        status.toInt() == 4
            ? _DeliveryProcess.complete(statusModal)
            : _DeliveryProcess.complete(statusModal)
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    required this.status,
    required this.token,
    this.acceptdate,
    required this.deliveryProcesses,
  });

  final int status;
  final String token;
  final String? acceptdate;

  final List<_DeliveryProcess> deliveryProcesses;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  _DeliveryProcess.complete(var statusModal)
      : this.name = 'Done',
        this.messages = [
          _DeliveryMessage(
              statusModal.verifyTime, ': Seat is alloted in university'),
          _DeliveryMessage('Assigned Roll No :', statusModal.assignedRoll),
        ];
  _DeliveryProcess.approval(var statusModal)
      : this.name = 'Admission approved',
        this.messages = [
          _DeliveryMessage(
              statusModal.acceptTime, ': Application recieved by verifier'),
          _DeliveryMessage(
              statusModal.acceptTime, ': wait for councelling date'),
        ];
  _DeliveryProcess.verification(var statusModal)
      : this.name = 'Documents verified',
        this.messages = [
          _DeliveryMessage(
              statusModal.acceptTime, ': Documents Verified Sucessfully'),
          _DeliveryMessage(
              statusModal.acceptTime, ': Wait for seat Allotement'),
        ];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
  bool get isapproval => name == 'approved';
  bool get isverification => name == 'verified';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String? createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}
