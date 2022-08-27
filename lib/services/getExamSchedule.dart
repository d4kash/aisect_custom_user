// import 'package:flutter/material.dart';

// class FuturePage extends StatelessWidget {
//   /// Function that will return a
//   /// "string" after some time
//   /// To demonstrate network call
//   /// delay of [2 seconds] is used
//   ///
//   /// This function will behave as an
//   /// asynchronous function
//   Future getData() {
//     return Future.delayed(Duration(seconds: 2), () {
//       return "I am data";
//       // throw Exception("Custom Error");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: FutureBuilder(
//           builder: (ctx, snapshot) {
//             // Checking if future is resolved or not
//             if (snapshot.connectionState == ConnectionState.done) {
//               // If we got an error
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text(
//                     '${snapshot.error} occured',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 );

//                 // if we got our data
//               } else if (snapshot.hasData) {
//                 // Extracting data from snapshot object
//                 final data = snapshot.data as String;
//                 return Center(
//                   child: Text(
//                     '$data',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 );
//               }
//             }

//             // Displaying LoadingSpinner to indicate waiting state
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           },

//           // Future that needs to be resolved
//           // inorder to display something on the Canvas
//           future: getData(),
//         ),
//       ),
//     );
//   }
// }
