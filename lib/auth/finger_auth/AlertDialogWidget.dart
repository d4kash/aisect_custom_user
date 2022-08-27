import 'dart:async';

import 'package:aisect_custom/auth/LoginHomeScreen.dart';

import 'package:flutter/material.dart';

showAlertDialogForNoSensorFound(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(" YOUR DEVICE HAS NO FINGERPRINT SENSOR, SET FINGERPRINT"),
    actions: [
      TextButton(
          onPressed: () => Timer(
              Duration(milliseconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePageForauth()),
                  (route) => false)),
          child: Text("OK"))
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

// showLoaderDialog(BuildContext context){
//     AlertDialog alert=AlertDialog(
//       content: new Row(
//         children: [
//           CircularProgressIndicator(),
//           Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
//         ],),
//     );
//     showDialog(barrierDismissible: false,
//       context:context,
//       builder:(BuildContext context){
//         return alert;
//       },
//     );
//   }

showAlertDialogForUserCancelAuth(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text("YOU HAVE NOT AUTHORIZED TO USE THIS APP"),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePageForauth()),
                (route) => false);
          },
          child: Text("CLOSE APP"))
    ],
  );

  // navigateUser() {
  //   if (_auth.currentUser != null) {
  //     Timer(
  //         Duration(milliseconds: 3),
  //         () => Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(builder: (context) => zoomDrawerHome())));
  //   } else {
  //     Timer(
  //         Duration(milliseconds: 4),
  //         () => Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => HomePageForauth()),
  //             (route) => false));
  //   }
  // }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}
