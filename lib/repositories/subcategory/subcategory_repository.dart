import 'dart:convert';

import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';
import 'package:billy/utils/icon_converter.dart';

import '../../models/subcategory/subcategory.dart';
import '../database_helper.dart';
import 'i_subcategory_repository.dart';

class SubcategoryRepository implements ISubcategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Subcategory> create(Subcategory subcategory) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('subcategories', subcategory.toMap());

    final createdTransaction = await db.query('subcategories',
        where: 'id = ?', whereArgs: [id], limit: 1);

    return Subcategory.fromMap(createdTransaction[0]);
  }

  @override
  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('subcategories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Subcategory?> getById(int id) async{
    final db = await _databaseHelper.database;

    var found = await db.query('subcategories', where: 'id = ?', whereArgs: [id]);

    return found.isNotEmpty ? Subcategory.fromMap(found[0]) : null;

  }

  @override
  Future<Subcategory> update(Subcategory subcategory) async{
    final db = await _databaseHelper.database;
    await db.update('subcategories', subcategory.toMap(), where: 'id = ?', whereArgs: [subcategory.id]);
    final updatedCategory = await db.query('subcategories', where: 'id = ?', whereArgs: [subcategory.id]);
    return Subcategory.fromMap(updatedCategory[0]);
  }

  @override
  Future<List<Subcategory>> getAll() async{
    final db = await _databaseHelper.database;
    var subcategories = await db.query("subcategories");
    return subcategories.map((sub){
      return Subcategory.fromMap(sub);
    }).toList();
  }
}
