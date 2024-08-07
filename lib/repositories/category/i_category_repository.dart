import '../../models/category/category.dart';

abstract class ICategoryRepository{
  Future<Category> create(Category category);
  Future<List<Category>?> getAll();
}