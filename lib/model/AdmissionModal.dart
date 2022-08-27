import 'dart:convert';

class AdmissionModal {
  String full_name;
  String D_O_B;
  String father_name;
  String mother_name;
  String Email;
  String Phone_No;
  String Aadhar_No;
  String Course;
  String Discipline;
  String Vill;
  String PO;
  String District;
  String State;
  String Pincode;
  String Exam_Roll_NO;
  String Last_Exam_Qualified;
  String Percent;
  String board;
  int status;
  String? token;
  String? Marksheet_no;
  String? Reciept_no;
  String? verifier_name;
  String? batch;
  String? Date;

  AdmissionModal(
      {required this.full_name,
      required this.D_O_B,
      required this.father_name,
      required this.mother_name,
      required this.Email,
      required this.Phone_No,
      required this.Aadhar_No,
      required this.Course,
      required this.Discipline,
      required this.Vill,
      required this.PO,
      required this.District,
      required this.State,
      required this.Pincode,
      required this.Exam_Roll_NO,
      required this.Last_Exam_Qualified,
      required this.Percent,
      required this.board,
      required this.status,
      this.token,
      this.Marksheet_no,
      this.Reciept_no,
      this.verifier_name,
      this.batch,
      this.Date});

  Map<String, dynamic> toMap() {
    return {
      'full_name': full_name,
      'D_O_B': D_O_B,
      'father_name': father_name,
      'mother_name': mother_name,
      'Email': Email,
      'Phone_No': Phone_No,
      'Aadhar_No': Aadhar_No,
      'Selected Course': Course,
      'Selected Discipline': Discipline,
      'Vill': Vill,
      'PO': PO,
      'District': District,
      'State': State,
      'Pincode': Pincode,
      'Exam_Roll_NO': Exam_Roll_NO,
      'Last_Exam_Qualified': Last_Exam_Qualified,
      'Percent': Percent,
      'board': board,
      'status': status,
      'token': token,
      'Marksheet_no': Marksheet_no,
      'Reciept_no': Reciept_no,
      'verifier_name': verifier_name,
      'batch': batch,
      'Date': Date
    };
  }

  factory AdmissionModal.fromMap(Map<String, dynamic> map) {
    return AdmissionModal(
      full_name: map['full_name'] ?? '',
      D_O_B: map['D_O_B'] ?? '',
      father_name: map['father_name'] ?? '',
      mother_name: map['mother_name'] ?? '',
      Email: map['Email'] ?? '',
      Phone_No: map['Phone_No'] ?? '',
      Aadhar_No: map['Aadhar_No'] ?? '',
      Course: map['Selected Course'] ?? '',
      Discipline: map['Selected Discipline'] ?? '',
      Vill: map['Vill'] ?? '',
      PO: map['PO'] ?? '',
      District: map['District'] ?? '',
      State: map['State'] ?? '',
      Pincode: map['Pincode'] ?? '',
      Exam_Roll_NO: map['Exam_Roll_NO'] ?? '',
      Last_Exam_Qualified: map['Last_Exam_Qualified'] ?? '',
      Percent: map['Percent'] ?? '',
      board: map['board'] ?? '',
      status: map['status']?.toInt() ?? 0,
      token: map['token'],
      Marksheet_no: map['Marksheet_no'] ?? '',
      Reciept_no: map['Reciept_no'] ?? '',
      verifier_name: map['verifier_name'] ?? '',
      batch: map['batch'] ?? '',
      Date: map['Date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdmissionModal.fromJson(String source) =>
      AdmissionModal.fromMap(json.decode(source));
}
