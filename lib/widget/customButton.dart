import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
  }) : super(key: key);
  final GestureTapCallback onPressed;
  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.orange,
      splashColor: const Color.fromARGB(255, 211, 105, 240),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
