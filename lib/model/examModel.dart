import 'dart:convert';

class ExamModel {
  final String? a;
  final String? b;
  final String? c;
  final String? d;
  final String? e;
  final String? f;
  final String? g;
  final String? h;
  final String? i;
  final String? j;
  final String? k;

  ExamModel(
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.i,
    this.j,
    this.k,
  );

  Map<String, dynamic> toMap() {
    return {
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'e': e,
      'f': f,
      'g': g,
      'h': h,
      'i': i,
      'j': j,
      'k': k,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      map['1'] ?? '',
      map['2'] ?? '',
      map['3'] ?? '',
      map['4'] ?? '',
      map['5'] ?? '',
      map['6'] ?? '',
      map['7'] ?? '',
      map['8'] ?? '',
      map['9'] ?? '',
      map['10'] ?? '',
      map['11'] ?? '',
    );
  }
  factory ExamModel.fromMapPractical(Map<String, dynamic> map) {
    return ExamModel(
      map['1'] ?? '',
      map['2'] ?? '',
      map['3'] ?? '',
      map['4'] ?? '',
      map['5'] ?? '',
      map['6'] ?? '',
      map['7'] ?? '',
      map['8'] ?? '',
      map['9'] ?? '',
      map['10'] ?? '',
      map['11'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExamModel.fromJson(String source) =>
      ExamModel.fromMap(json.decode(source));
}
