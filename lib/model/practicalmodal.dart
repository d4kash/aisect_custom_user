import 'dart:convert';

class PracticalModal {
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
  PracticalModal({
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
  });

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
    };
  }

  factory PracticalModal.fromMap(Map<String, dynamic> map) {
    return PracticalModal(
      a: map['1'],
      b: map['2'],
      c: map['3'],
      d: map['4'],
      e: map['5'],
      f: map['6'],
      g: map['7'],
      h: map['8'],
      i: map['9'],
      j: map['10'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PracticalModal.fromJson(String source) =>
      PracticalModal.fromMap(json.decode(source));
}
