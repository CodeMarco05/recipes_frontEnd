import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  // Add your constants here
  static const String appName = 'Marie und Marco';
  static const int maxItems = 10;
  static const double defaultPadding = 16.0;

  static const String playwrite_font = "Playwrite";
  static const String exo_font = "Exo";

  static const String server_url = 'https://backend-recipe.prydox-tech.de';

  static TextStyle defaultTextStyle({
    String fontFamily = exo_font,
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
