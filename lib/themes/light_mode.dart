import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Colors.grey.shade200,
        secondary: Colors.white,
        inversePrimary: Colors.grey.shade700
    ),
    fontFamily: "Intel",
    brightness: Brightness.light,

);

ThemeData darkMode = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF171717),
      primary: Color(0xFFDA0037),
      secondary: Color(0xFF444444),
      inversePrimary:Color(0xFFEDEDED),
    ),
  fontFamily: "StudioSans"
);