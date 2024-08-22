import 'dart:convert';

import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';
import 'package:billy/utils/icon_converter.dart';

import '../../models/subcategory/subcategory.dart';
import '../../utils/color_converter.dart';
import '../database_helper.dart';

class CategoryRepository implements ICategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<TransactionCategory> create(TransactionCategory category) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('categories', category.toMap());

    final createdTransaction = await db.query('categories',
        where: 'id = ?', whereArgs: [id], limit: 1);

    return TransactionCategory.fromMap(createdTransaction[0]);
  }

  @override
  Future<List<TransactionCategory>?> getAll() async {
    final db = await _databaseHelper.database;
    final foundCategories = await db.rawQuery('''
      SELECT 
        categories.id AS id,
        categories.name AS name,
        categories.icon AS icon,
        categories.color AS color, 
        subcategories.id AS subcategory_id,
        subcategories.name AS subcategory_name,
        subcategories.color AS subcategory_color,
        subcategories.icon AS subcategory_icon 
      FROM categories
      LEFT JOIN subcategories
      ON subcategories.category_id = categories.id
      ORDER BY categories.name COLLATE NOCASE;
  ''');

    final List<TransactionCategory> categories = [];
    final Map<int, TransactionCategory> categoryMap = {};

    for (var result in foundCategories) {
      final categoryId = result['id'] as int?;
      final subcategoryId = result['subcategory_id'] as int?;

      if (categoryId == null) {
        continue; // Pula se o id da categoria for nulo
      }

      // Verifica se a categoria já existe no mapa
      if (!categoryMap.containsKey(categoryId)) {
        categoryMap[categoryId] = TransactionCategory(
          id: categoryId,
          name: result['name'] as String,
          color: ColorConverter.intToColor(result['color'] as int),
          icon: IconConverter.parseIconFromDb(jsonDecode(result['icon'] as String)),
          subcategories: [],
        );
        categories.add(categoryMap[categoryId]!);
      }

      // Adiciona a subcategoria à lista de subcategorias da categoria
      if (subcategoryId != null) {
        categoryMap[categoryId]!.subcategories!.add(
          Subcategory(
            id: subcategoryId,
            parentId: categoryId,
            name: result['subcategory_name'] as String,
            color: ColorConverter.intToColor(result['subcategory_color'] as int),
            icon: IconConverter.parseIconFromDb(jsonDecode(result['subcategory_icon'] as String)),
          ),
        );
      }
    }

    return categories;
  }

  @override
  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;
    await db.update('transactions', {'category_id':null, 'subcategory_id':null}, where: 'category_id = ?', whereArgs: [id]);
    await db.delete('subcategories', where: 'category_id = ?', whereArgs: [id]);
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<TransactionCategory?> getById(int id) async{
    final db = await _databaseHelper.database;

    var found = await db.query('categories', where: 'id = ?', whereArgs: [id]);

    return found.isNotEmpty ? TransactionCategory.fromMap(found[0]) : null;

  }

  @override
  Future<TransactionCategory> update(TransactionCategory category) async{
    final db = await _databaseHelper.database;
    await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
    final updatedCategory = await db.query('categories', where: 'id = ?', whereArgs: [category.id]);
    return TransactionCategory.fromMap(updatedCategory[0]);
  }
}
