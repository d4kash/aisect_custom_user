import 'dart:convert';

class PaymentModel {
  final String status;
  final String message;
  final String cftoken;

  PaymentModel(this.status, this.message, this.cftoken);

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'cftoken': cftoken,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      map['status'] ?? '',
      map['message'] ?? '',
      map['cftoken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source));
}
