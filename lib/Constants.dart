import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  // Add your constants here
  static const String appName = 'Marie und Marco';
  static const int maxItems = 10;
  static const double defaultPadding = 16.0;

  static const String playwriteFont = "Playwrite";
  static const String exoFont = "Exo";

  static const String serverUrl = 'https://backend-recipe.prydox-tech.de';

  static TextStyle defaultTextStyle({
    String fontFamily = exoFont,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
