import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';

class ListCategoriesUseCase{
  final ICategoryRepository repository;

  const ListCategoriesUseCase({required this.repository});

  Future<List<TransactionCategory>> execute() async{
    var categories = await repository.getAll();
    return categories ?? [];
  }
}