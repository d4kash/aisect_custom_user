import 'dart:convert';

class ProfileModal {
  String? full_name;
  String? Phone_No;
  String? email;
  String? Course;
  String? Discipline;
  String? Roll;
  String? ProfileUrl;
  String? ExamRoll;
  String? batch;
  String? semester;
  String? Faculty;

  ProfileModal({
    this.full_name,
    this.Phone_No,
    this.email,
    this.Course,
    this.Discipline,
    this.Roll,
    this.ProfileUrl,
    this.ExamRoll,
    this.batch,
    this.semester,
    this.Faculty,
  });

  Map<String, dynamic> toMap() {
    return {
      'full name': full_name,
      'Phone No': Phone_No,
      'email': email,
      'Course': Course,
      'Discipline': Discipline,
      'Roll': Roll,
      'ProfileUrl': ProfileUrl,
      'ExamRoll': ExamRoll,
      'batch': batch,
      'semester': semester,
      'Faculty': Faculty,
    };
  }

  factory ProfileModal.fromMap(Map<String, dynamic> map) {
    return ProfileModal(
      full_name: map['full name'] ?? '',
      Phone_No: map['Phone No'] ?? '',
      email: map['email'] ?? '',
      Course: map['Course'] ?? '',
      Discipline: map['Discipline'] ?? '',
      Roll: map['Roll'] ?? '',
      ProfileUrl: map['ProfileUrl'] ?? '',
      ExamRoll: map['ExamRoll'] ?? '',
      batch: map['batch'] ?? '',
      semester: map['semester'] ?? '',
      Faculty: map['Faculty'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModal.fromJson(String source) =>
      ProfileModal.fromMap(json.decode(source));
}
