import 'package:flutter/material.dart';

//0xFFEF7822
// final newColor = Color(0xFFEF7822);
//
final color = Color(0xff023560);
ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: color,
  secondaryHeaderColor: Color(0xFF000743),
  disabledColor: Color(0xFFA0A4A8),
  errorColor: Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: color, secondary: color),
  textButtonTheme:
      TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
);
