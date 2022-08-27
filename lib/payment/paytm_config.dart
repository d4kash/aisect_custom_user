// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;

// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

// class PaytmConfig {
//   final String _mid = "cKJenS73916317236658";
//   final String _mKey = "0jBS70PK&OiGbvGA";
//   final String _website = "WEBSTAGING";
//   final String _url =
//       'https://flutter-paytm-backend.herokuapp.com/generateTxnToken';

//   String get mid => _mid;
//   String get mKey => _mKey;
//   String get website => _website;
//   String get url => _url;

//   String getMap(double amount, String callbackUrl, String orderId) {
//     return json.encode({
//       "mid": mid,
//       "key_secret": mKey,
//       "website": website,
//       "orderId": orderId,
//       "amount": amount.toString(),
//       "callbackUrl": callbackUrl,
//       "custId": "122",
//     });
//   }

//   Future generateTxnToken(double amount, String orderId) async {
//     final callBackUrl =
//         'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
//     final body = getMap(amount, callBackUrl, orderId);
//     // Dio dio = Dio();
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//       String txnToken = response.body;
//       print(response.statusCode);
//       print(response.body);
//       // await initiateTransaction(orderId, amount, txnToken, callBackUrl);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> initiateTransaction(String orderId, double amount,
//       String txnToken, String callBackUrl) async {
//     String result = '';
//     try {
//       var response = AllInOneSdk.startTransaction(
//         mid,
//         orderId,
//         amount.toString(),
//         txnToken,
//         callBackUrl,
//         false,
//         false,
//       );
//       response.then((value) {
//         // Transaction successfull
//         print(value);
//       }).catchError((onError) {
//         if (onError is PlatformException) {
//           result = onError.message! + " \n  " + onError.details.toString();
//           print(result);
//         } else {
//           result = onError.toString();
//           print(result);
//         }
//       });
//     } catch (err) {
//       // Transaction failed
//       result = err.toString();
//       print(result);
//     }
//   }
// }
