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

  TransactionCategory copyWith({
    int? id,
    String? name,
    Color? color,
    IconData? icon,
    List<Subcategory>? subcategories,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      subcategories: subcategories ?? this.subcategories,
    );
  }

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
      id: map['category_id'] ?? map['id'],
      name: map['category_name']?? map['name'],
      color: ColorConverter.intToColor(map['category_color'] ?? map['color']),
      icon: IconConverter.parseIconFromDb(jsonDecode(map['category_icon'] ?? map['icon'])),
      subcategories: map['subcategory_id'] != null ? [Subcategory.fromMap(map)] : [],
    );
  }
}
