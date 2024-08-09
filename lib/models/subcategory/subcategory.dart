import 'dart:convert';

import 'package:billy/utils/color_converter.dart';
import 'package:billy/utils/icon_converter.dart';
import 'package:flutter/material.dart';

class Subcategory {
  int? id;
  int parentId;
  String name;
  Color color;
  IconData icon;

  Subcategory(
      {this.id,
      required this.parentId,
      required this.name,
      required this.color,
      required this.icon});

  Subcategory.empty(
      {this.id,
      this.parentId = -1,
      this.name = "",
      this.color = const Color(0xFFFFFFFF),
      this.icon = Icons.question_mark});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': parentId,
      'name': name,
      'color': ColorConverter.colorToInt(color),
      'icon': IconConverter.parseIconToDb(icon)
    };
  }

  static Subcategory fromMap(Map<String, dynamic> map) {
    return Subcategory(
        id: map['subcategory_id'] ?? map['id'],
        parentId: map['category_id'],
        name: map['subcategory_name'] ??  map['name'],
        color: map['subcategory_color'] ?? ColorConverter.intToColor(map['color']),
        icon: map['subcategory_icon'] ?? IconConverter.parseIconFromDb(jsonDecode(map['icon'])));
  }
}
