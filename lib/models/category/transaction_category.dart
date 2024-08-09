import 'dart:convert';
import 'dart:ui';

import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/utils/icon_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../../utils/color_converter.dart';

class TransactionCategory {
  int? id;
  String name;
  Color color;
  IconData icon;
  List<Subcategory>? subcategories;

  TransactionCategory(
      {this.id,
      required this.name,
      required this.color,
      required this.icon,
      this.subcategories});

  TransactionCategory.empty(
      {this.name = "",
      this.color = const Color(0xFFFFFFFF),
      this.icon = Icons.question_mark});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': ColorConverter.colorToInt(color),
      'icon': IconConverter.parseIconToDb(icon),
    };
  }

  static TransactionCategory fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'],
      name: map['name'],
      color: ColorConverter.intToColor(map['color']),
      icon: IconConverter.parseIconFromDb(jsonDecode(map['icon'])),
      subcategories: [],
    );
  }
}
