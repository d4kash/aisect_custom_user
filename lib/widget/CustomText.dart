// // import 'package:flutter/material.dart';

// // class NeoText extends StatelessWidget {
// //   final String text;
// //   final double size;
// //   final FontWeight fontWeight;
// //   final Color color;
// //   final double wordSpacing;
// //   // final VoidCallback onClick;

// //   const NeoText({
// //     required this.text,
// //     required this.size,
// //     required this.fontWeight,
// //     required this.color,
// //     required this.wordSpacing,
// //     // required this.onClick,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }
// import 'package:flutter/material.dart';

// class TextField_resultBx extends StatelessWidget {
//   const TextField_resultBx({
//     Key? key,
//     required this.boxResultTitle,
//     required this.borderLabelTextBox,
//     required this.displayBoxResult,
//   }) : super(key: key);

//   final String boxResultTitle;
//   final String borderLabelTextBox;
//   final String displayBoxResult;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             boxResultTitle,
//             textScaleFactor: 1.2,
//             softWrap: true,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Results Box 1:
//           TextField(
//             // enabled: true,
//             readOnly: true,
//             style: const TextStyle(
//               color: Colors.black,
//             ),
//             decoration: InputDecoration(
//               enabled: true,
//               contentPadding: const EdgeInsets.all(12.0),
//               floatingLabelBehavior: FloatingLabelBehavior.always,
//               // Border Label TextBox 1
//               labelText: borderLabelTextBox,
//               labelStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: kCalLabelColor,
//               ),
//               hintText: displayBoxResult,

//               hintMaxLines: 2,
//               hintStyle: const TextStyle(
//                 color: Colors.black,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: kEnbBorderSide,
//                 borderRadius: kCalOutlineBorderRad,
//               ),
//               focusedBorder: kFocusedBorder,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
