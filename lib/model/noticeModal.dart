import 'dart:convert';

class NoticeModal {
  final String notice_no;
  final String notice_title;
  final String notice_message;
  String? faculty;
  String? date_time;
  bool? read;
  NoticeModal({
    required this.notice_no,
    required this.notice_title,
    required this.notice_message,
    this.faculty,
    this.date_time,
    this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'notice_no': notice_no,
      'notice_title': notice_title,
      'notice_message': notice_message,
      'faculty': faculty,
      'date_time': date_time,
      'read': read,
    };
  }

  factory NoticeModal.fromMap(Map<String, dynamic> map) {
    return NoticeModal(
      notice_no: map['notice_no'] ?? '',
      notice_title: map['notice_title'] ?? '',
      notice_message: map['notice_message'] ?? '',
      faculty: map['faculty'],
      date_time: map['date_time'],
      read: map['read'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeModal.fromJson(String source) =>
      NoticeModal.fromMap(json.decode(source));

  NoticeModal copyWith({
    String? notice_no,
    String? notice_title,
    String? notice_message,
    String? faculty,
    String? date_time,
    bool? read,
  }) {
    return NoticeModal(
      notice_no: notice_no ?? this.notice_no,
      notice_title: notice_title ?? this.notice_title,
      notice_message: notice_message ?? this.notice_message,
      faculty: faculty ?? this.faculty,
      date_time: date_time ?? this.date_time,
      read: read ?? this.read,
    );
  }

  @override
  String toString() {
    return 'NoticeModal(notice_no: $notice_no, notice_title: $notice_title, notice_message: $notice_message, faculty: $faculty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoticeModal &&
        other.notice_no == notice_no &&
        other.notice_title == notice_title &&
        other.notice_message == notice_message &&
        other.faculty == faculty;
  }

  @override
  int get hashCode {
    return notice_no.hashCode ^
        notice_title.hashCode ^
        notice_message.hashCode ^
        faculty.hashCode;
  }
}
