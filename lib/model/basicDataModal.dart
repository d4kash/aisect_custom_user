import 'dart:convert';

class BasicDataModal {
  String name;
  String phone;
  String examRoll;
  String batch;
  String faculty;
  String semester;
  String role;
  bool isHomeVisited;
  BasicDataModal({
    required this.name,
    required this.phone,
    required this.examRoll,
    required this.batch,
    required this.faculty,
    required this.semester,
    required this.role,
    required this.isHomeVisited,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'ExamRoll': examRoll,
      'batch': batch,
      'Faculty': faculty,
      'semester': semester,
      'role': role,
      'isHomeVisited': isHomeVisited,
    };
  }

  factory BasicDataModal.fromMap(Map<String, dynamic> map) {
    return BasicDataModal(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      examRoll: map['ExamRoll'] ?? '',
      batch: map['batch'] ?? '',
      faculty: map['Faculty'] ?? '',
      semester: map['semester'] ?? '',
      role: map['role'] ?? '',
      isHomeVisited: map['isHomeVisited'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicDataModal.fromJson(String source) =>
      BasicDataModal.fromMap(json.decode(source));
}
