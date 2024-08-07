import 'package:billy/models/category/category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';

import '../database_helper.dart';

class CategoryRepository implements ICategoryRepository{

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Category> create(Category category) async{
    final db = await _databaseHelper.database;
    final id = await db.insert('categories', category.toMap());

    final createdTransaction = await db.query('categories', where: 'id = ?', whereArgs: [id], limit: 1);

    return Category.fromMap(createdTransaction[0]);
  }

  @override
  Future<List<Category>?> getAll() async{
    final db = await _databaseHelper.database;
    final categories = await db.query('categories');

    return categories.map((element)=> Category.fromMap(element)).toList();
  }

}