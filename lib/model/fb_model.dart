import 'dart:convert';

class FbModel {
  final String name;
  final String course;
  final String discipline;
  final String phone;
  final String email;

  FbModel(
    this.name,
    this.course,
    this.discipline,
    this.phone,
    this.email,
  );

  Map<String, dynamic> toMap() {
    return {
      'full name': name,
      'Course': course,
      'Discipline': discipline,
      'Phone No': phone,
      'email': email,
    };
  }

  factory FbModel.fromMap(Map<String, dynamic> map) {
    return FbModel(
      map['full name'] ?? '',
      map['Course'] ?? '',
      map['Discipline'] ?? '',
      map['Phone No'] ?? '',
      map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FbModel.fromJson(String source) =>
      FbModel.fromMap(json.decode(source));
}
