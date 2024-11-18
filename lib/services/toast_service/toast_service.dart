import 'package:billy/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService{

  static void showToast({String? message}){
    Fluttertoast.showToast(
      msg: message ?? "Ok",
      toastLength: Toast.LENGTH_SHORT, // ou Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM,    // TOP, CENTER, BOTTOM
      backgroundColor: ThemeColors.semanticGreen,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}