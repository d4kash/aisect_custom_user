import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../GetController/theme_controller.dart';
import '../widget/appBar.dart';

class RazorPay extends StatefulWidget {
  String name;
  String phone;
  String amount;
  var data;
  RazorPay({
    Key? key,
    required this.name,
    required this.phone,
    required this.amount,
    this.data,
  }) : super(key: key);

  @override
  _RazorPayState createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  static const platform = MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  var controller = Get.put(RadioController());
  // controller.paymentStatus.value = 'waiting..';
  // String amount = '800';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarScreen(
          title: 'Payment Options',
        ),
        body: Center(child: Obx(() => Text(controller.paymentStatus.string))));
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future savePaymentToDB(var data, var response) async {
    try {
      var collection = FirebaseFirestore.instance.collection('Payment_Section');
      return collection
          .doc(data['batch'])
          .collection(data['semester'])
          .doc(data['Faculty'])
          .collection(data['StudentRollList'])
          .doc(data['ExamRoll'])
          .set({
        'Name': data['name'],
        'phone': data['phone'],
        'status': 'Success',
        'PaymentId': response.paymentId!,
        'OrderId': response.orderId
      });

      // print(Constant.roll);
      // print(Constant.batchfromDB);
      // print(Constant.semFromDB);
      // print(Constant.faculty);
    } catch (e) {
      print(e.toString());
    }
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_h4pKMAkdJDIXL4',
      'amount': (int.parse(widget.amount) * 100).toString(),
      'name': 'Aisect university',
      'description': 'Exam Fee',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': widget.phone, 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm', 'phonepe']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    print('Success Response: ${response.orderId}');
    await savePaymentToDB(widget.data, response);
    controller.paymentStatus.value = 'Success';
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');

    controller.paymentStatus.value = 'Something Went Wrong';
    Fluttertoast.showToast(
        msg: "ERROR: Payment failed", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    print('External SDK Response: $response');
    controller.paymentStatus.value = response.walletName!;
    await savePaymentToDB(widget.data, response);
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
}
