import 'dart:convert';
import 'dart:ui';

import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/presentation/shared/utils/color_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class TransactionCategory {
  int? id;
  String name;
  Color color;
  IconData icon;
  Subcategory? subcategory;

  TransactionCategory(
      {this.id,
      required this.name,
      required this.color,
      required this.icon,
      this.subcategory});

  TransactionCategory.empty(
      {this.name = "",
      this.color = const Color(0xFFFFFFFF),
      this.icon = Icons.question_mark});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': ColorConverter.colorToInt(color),
      'icon': _parseIconToDb(icon),
      'subcategory_id': subcategory
    };
  }

  static TransactionCategory fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'],
      name: map['name'],
      color: ColorConverter.intToColor(map['color']),
      icon: _parseIconFromDb(jsonDecode(map['icon'])),
      subcategory: map['subcategory'],
    );
  }

  static String _parseIconToDb(IconData icon) {
    Map<String, dynamic> serializedIcon = serializeIcon(icon, iconPack: IconPack.fontAwesomeIcons)!;
    String iconJson = jsonEncode(serializedIcon);
    return iconJson;
  }

  static IconData _parseIconFromDb(Map<String, dynamic> icon){
    return deserializeIcon(icon) ?? Icons.warning_amber;
  }
}
