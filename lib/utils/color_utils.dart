import 'package:flutter/material.dart';

class ColorUtils{
  static getContrastingTextColor(Color backgroundColor){
    final double luminance = 0.2126 * backgroundColor.red / 255 +
        0.7152 * backgroundColor.green / 255 +
        0.0722 * backgroundColor.blue / 255;

    return luminance > .5 ? Colors.black : Colors.white;
  }
}