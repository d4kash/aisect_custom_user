import 'package:aisect_custom/Home/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtonNew extends StatelessWidget {
  CustomButtonNew({
    Key? key,
    // required this.formKey,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  // final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        color: AppColors.buttonColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 150,
              height: 50,
              alignment: Alignment.center,
              child:  Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            onTap: onPressed
            // onTap: () {
            //   if (formKey.currentState!.validate()) {
            //     FocusScope.of(context).unfocus();
            //     // addUserEnq();
            //     // _createPdf();
            //     // clearTextInput();
            //     print("check success");
            //     // showDialog(
            //     //   context: context,
            //     //   builder: (_) => AdvanceDialog(
            //     //       title: "Sucess",
            //     //       s: " Your Enquiry is submitted"),
            //     // );
            //   } else {
            //     print("check fails");
            //     Constant.showSnackBar(context, "* All Fields are required !");
            //     // Fluttertoast.showToast(
            //     //     msg: "All Fields are required",
            //     //     toastLength: Toast.LENGTH_SHORT,
            //     //     gravity: ToastGravity.BOTTOM,
            //     //     timeInSecForIosWeb: 1,
            //     //     backgroundColor: Colors.red,
            //     //     textColor: Colors.white,
            //     //     fontSize: 16.0);
            //   }
            //   print("Button Tapped");
            // },
            ),
      ),
    );
  }
}
