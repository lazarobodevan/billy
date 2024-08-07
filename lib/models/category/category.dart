import 'dart:ui';

import 'package:billy/models/subcategory/subcategory.dart';

class Category{
  int? id;
  String name;
  Color color;
  Subcategory? subcategory;

  Category({this.id, required this.name, required this.color, this.subcategory});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'subcategory': subcategory
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      subcategory: map['subcategory']
    );
  }
}