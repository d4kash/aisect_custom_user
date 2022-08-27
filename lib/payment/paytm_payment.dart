import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmPayment {
/*

HEy everyone , today we are going to seee how to integrate PAYTM payment gateway in flutter
paytm integration can be divided into 3 parts
1 -> txToken generation
2 -> checkout
3 -> payment status verification

first let's see backend set up
1st txtoken generation


let's see UI

we got a textfield and a button
here
you have to enter amount click button, on click token generation api 
that's all let's see complete code then demo
before that there are some platform spefici thing
let's see it in action
thanks for watching
*/

  static Future initiateTransaction(String amount, BuildContext context) async {
    Map<String, dynamic> body = {
      'amount': amount,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "paytmphpapp.herokuapp.com", // my ip address , localhost
        "generate_token.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var bodyJson = jsonDecode(res.body);
      //  on success of txtoken generation api
      //  start transaction

      var response = AllInOneSdk.startTransaction(
        bodyJson['mid'], // merchant id  from api
        bodyJson['orderId'], // order id from api
        amount, // amount
        bodyJson['txnToken'], // transaction token from api
        "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$bodyJson['orderId']", // callback url
        true, // isStaging
        false, // restrictAppInvoke
      ).then((value) {
        //  on payment completion we will verify transaction with transaction verify api
        //  after payment completion we will verify this transaction
        //  and this will be final verification for payment

        print(value);
        verifyTransaction(bodyJson['orderId'], context);
      }).catchError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  static void verifyTransaction(String orderId, BuildContext context) async {
    Map<String, dynamic> body = {
      'orderId': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "paytmphpapp.herokuapp.com", // my ip address , localhost
        "verify_transaction.php", // let's check verifycation code on backend
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    print(res.statusCode);
// json decode
    var verifyJson = jsonDecode(res.body);
//  display result info > result msg

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(verifyJson['body']['resultInfo']['resultMsg']),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
