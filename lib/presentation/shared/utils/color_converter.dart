import 'package:flutter/material.dart';

class ColorConverter {
  static colorToInt(Color color) {
    return color.value;
  }

  static intToColor(int colorInt) {
    return Color(colorInt);
  }
}
