import 'package:billy/models/subcategory/subcategory.dart';

import '../../models/category/transaction_category.dart';

abstract class ISubcategoryRepository{
  Future<Subcategory> create(Subcategory subcategory);
  Future<Subcategory?> getById(int id);
  Future<void> delete(int id);
  Future<Subcategory> update(Subcategory category);
}