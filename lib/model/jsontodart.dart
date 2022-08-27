//Model
import 'dart:convert';

class Model {
  final String department;
  final String course;
  final String csn;
  final String duration;
  final String eligiblity;
  final String fee;

  Model(this.department, this.course, this.csn, this.duration, this.eligiblity,
      this.fee);

  Map<String, dynamic> toMap() {
    return {
      'department': department,
      'course': course,
      'csn': csn,
      'duration': duration,
      'eligiblity': eligiblity,
      'Fee': fee,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      map['department'] ?? '',
      map['course'] ?? '',
      map['csn'] ?? '',
      map['duration'] ?? '',
      map['eligiblity'] ?? '',
      map['Fee'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source));

  Model copyWith({
    String? department,
    String? course,
    String? csn,
    String? duration,
    String? eligiblity,
    String? fee,
  }) {
    return Model(
      department ?? this.department,
      course ?? this.course,
      csn ?? this.csn,
      duration ?? this.duration,
      eligiblity ?? this.eligiblity,
      fee ?? this.fee,
    );
  }

  @override
  String toString() {
    return 'Model(department: $department, course: $course, csn: $csn, duration: $duration, eligiblity: $eligiblity, Fee: $fee)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model &&
        other.department == department &&
        other.course == course &&
        other.csn == csn &&
        other.duration == duration &&
        other.eligiblity == eligiblity &&
        other.fee == fee;
  }

  @override
  int get hashCode {
    return department.hashCode ^
        course.hashCode ^
        csn.hashCode ^
        duration.hashCode ^
        eligiblity.hashCode ^
        fee.hashCode;
  }
}
