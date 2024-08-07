import 'package:flutter/material.dart';

class Subcategory{
  int? id;
  String name;
  Color color;
  IconData icon;

  Subcategory({this.id, required this.name, required this.color, required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon
    };
  }

  static Subcategory fromMap(Map<String, dynamic> map) {
    return Subcategory(
        id: map['id'],
        name: map['name'],
        color: map['color'],
        icon: map['icon']
    );
  }
}