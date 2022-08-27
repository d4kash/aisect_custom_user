import 'dart:convert';

class StatusModal {
  int status;
  String token;
  String assignedRoll;
  String? acceptTime;
  String? acceptDate;
  String? verifyTime;
  String? verifyDate;
  String? allotedDate;
  bool? appl_accepted;
  bool? document_verified;
  bool? isRoll_assigned;
  StatusModal({
    required this.status,
    required this.token,
    required this.assignedRoll,
    this.acceptTime,
    this.acceptDate,
    this.verifyTime,
    this.verifyDate,
    this.allotedDate,
    this.appl_accepted,
    this.document_verified,
    this.isRoll_assigned,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'token': token,
      'assignedRoll': assignedRoll,
      'acceptTime': acceptTime,
      'acceptDate': acceptDate,
      'verifyTime': verifyTime,
      'verifyDate': verifyDate,
      'allotedDate': allotedDate,
      'appl_accepted': appl_accepted,
      'document_verified': document_verified,
      'isRoll_assigned': isRoll_assigned,
    };
  }

  factory StatusModal.fromMap(Map<String, dynamic> map) {
    return StatusModal(
      status: map['status']?.toInt() ?? 0,
      token: map['token'] ?? '',
      assignedRoll: map['assignedRoll'] ?? '',
      acceptTime: map['acceptTime'],
      acceptDate: map['acceptDate'],
      verifyTime: map['verifyTime'],
      verifyDate: map['verifyDate'],
      allotedDate: map['allotedDate'],
      appl_accepted: map['appl_accepted'],
      document_verified: map['document_verified'],
      isRoll_assigned: map['isRoll_assigned'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModal.fromJson(String source) =>
      StatusModal.fromMap(json.decode(source));
}
