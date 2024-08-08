import '../../models/category/transaction_category.dart';

abstract class ICategoryRepository{
  Future<TransactionCategory> create(TransactionCategory category);
  Future<List<TransactionCategory>?> getAll();
}