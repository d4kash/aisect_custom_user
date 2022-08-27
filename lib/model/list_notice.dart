import 'dart:convert';

import 'package:aisect_custom/model/noticeModal.dart';

class NoticeList {
  List<NoticeModal>? students;
  NoticeList({
    required this.students,
  });

  Map<String, dynamic> toMap() {
    return {
      'students': students!.map((x) => x.toMap()).toList(),
    };
  }

  factory NoticeList.fromMap(Map<String, dynamic> map) {
    return NoticeList(
      students: map['students'] == null
          ? null
          : List<NoticeModal>.from(
              map['students']?.map((x) => NoticeModal.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeList.fromJson(String source) =>
      NoticeList.fromMap(json.decode(source));
}

class NoticeForAll {
  List<NoticeModal>? everyone;
  NoticeForAll({
    required this.everyone,
  });

  Map<String, dynamic> toMap() {
    return {
      'everyone': everyone?.map((x) => x.toMap()).toList(),
    };
  }

  factory NoticeForAll.fromMap(Map<String, dynamic> map) {
    return NoticeForAll(
      everyone: map['everyone'] != null
          ? List<NoticeModal>.from(
              map['everyone']?.map((x) => NoticeModal.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeForAll.fromJson(String source) =>
      NoticeForAll.fromMap(json.decode(source));
}
