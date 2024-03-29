import 'package:flutter/material.dart';

class Palette {
  static const Color darkBlue = Color(0xff092E34);
  static const Color lightBlue = Color(0xff489FB5);
  static const Color orange = Color(0xffFFA62B);
  static const Color darkOrange = Color(0xffCC7700);
}

class Themes {
  static final light = ThemeData.light()
      // ignore: deprecated_member_use
      .copyWith(
          backgroundColor: Colors.white54);
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black54,
    // ignore: deprecated_member_use
    buttonColor: Colors.deepOrange,
  );
}
