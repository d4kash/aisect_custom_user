import 'package:aisect_custom/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class widget {
  // late BuildContext context;
  Widget container(
    final List<List<Color>> color,
    final List<IconData> icons,
    final List<String> titles,
    final int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 20),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            height: Constant.height / 4.0,
            width: Constant.width / 2.5,
            // clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // color: Colors.grey,
              gradient: LinearGradient(
                colors: color[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[index],
                  size: Constant.height / 18,
                ),
                SizedBox(
                  height: Constant.height / 25,
                ),
                FittedBox(
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: Constant.height / 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// class FormText {
//   Widget formText(
//       final TextEditingController ctrl,
//       final Widget icon,
//       final String label,
//       final String? Function(String?)? validator,
//       final int? maxLength,
//       final List<TextInputFormatter>? inputFormatters,
//       final TextInputType? keyboardType) {
//     return VxTextField(
//       controller: ctrl,
//       fillColor: const Color.fromARGB(255, 243, 233, 233),
//       labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
//       icon: icon,
//       labelText: label,
//       borderType: VxTextFieldBorderType.underLine,
//       inputFormatters: inputFormatters,
//       validator: validator,
//     );
//   }
// }
/***Custom Text Class */
class CustomText extends StatelessWidget {
  final TextEditingController controller;
  final Widget icon;
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Color? color;
  final bool? readOnly;
  const CustomText(
      {Key? key,
      required this.controller,
      required this.icon,
      required this.label,
      this.inputFormatters,
      this.validator,
      this.maxLength,
      this.keyboardType,
      required this.color,
      this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(fontSize: height / 65),
        readOnly: readOnly!,
        controller: controller,
        validator: validator,
        maxLength: maxLength! > 0 ? maxLength : 60,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 63)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class FormTextCont {
  Widget formText(
    final TextEditingController controller,
    final Widget icon,
    final String label,
    final List<TextInputFormatter>? inputFormatters,
    final String? Function(String?)? validator,
    final int? maxLength,
    final TextInputType? keyboardType,
    final Color? color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLength: maxLength! > 0 ? maxLength : 30,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 63)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TextDisplay {
  Widget textDisplay(
    // final TextEditingController controller,
    // final Widget icon,
    final String label,
    final String hint,
    // final List<TextInputFormatter>? inputFormatters,
    // final String? Function(String?)? validator,
    // final int? maxLength,
    // final TextInputType? keyboardType,
    // final Color? color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        // controller: controller,
        // validator: validator,
        // maxLength: maxLength! > 0 ? maxLength : 30,
        // inputFormatters: inputFormatters,
        // keyboardType: keyboardType,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 63)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TextField_resultBx extends StatelessWidget {
  const TextField_resultBx({
    Key? key,
    this.boxResultTitle,
    required this.borderLabelTextBox,
    required this.displayBoxResult,
  }) : super(key: key);

  final String? boxResultTitle;
  final String borderLabelTextBox;
  final String displayBoxResult;

  @override
  Widget build(BuildContext context) {
    var kCalLabelColor = Colors.black;

    var kEnbBorderSide = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
      ),
    );

    var kFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   boxResultTitle!,
          //   textScaleFactor: 1.2,
          //   softWrap: true,
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const SizedBox(height: 10),
          // Results Box 1:
          TextField(
            // enabled: true,
            readOnly: true,
            style: TextStyle(
              color: kCalLabelColor,
            ),
            decoration: InputDecoration(
              enabled: true,
              contentPadding: const EdgeInsets.all(12.0),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // Border Label TextBox 1
              labelText: borderLabelTextBox,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kCalLabelColor,
              ),
              hintText: displayBoxResult,

              hintMaxLines: 2,
              hintStyle: const TextStyle(
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
              ),
              focusedBorder: kFocusedBorder,
            ),
          ),
        ],
      ),
    );
  }
}
