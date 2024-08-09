import '../../models/category/transaction_category.dart';

abstract class ICategoryRepository{
  Future<TransactionCategory> create(TransactionCategory category);
  Future<List<TransactionCategory>?> getAll();
  Future<TransactionCategory?> getById(int id);
  Future<void> delete(int id);
  Future<TransactionCategory> update(TransactionCategory category);
}