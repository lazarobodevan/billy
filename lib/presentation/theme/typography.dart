import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyStyles{
//Headlines
  static TextStyle headline1()=> GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold);
  static TextStyle headline2()=> GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold);
  static TextStyle headline3()=> GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold);

  //Labels
  static TextStyle label1()=> GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500);
  static TextStyle label2()=> GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle label3()=> GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle label4()=> GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);

  //Paragraphs
  static TextStyle paragraph1()=> GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.normal);
  static TextStyle paragraph2()=> GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal);
  static TextStyle paragraph3()=> GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal);
  static TextStyle paragraph4()=> GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal);
  static TextStyle paragraph5()=> GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.normal);
}