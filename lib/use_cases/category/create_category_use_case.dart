import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';

class CreateCategoryUseCase{
  final ICategoryRepository repository;

  const CreateCategoryUseCase({required this.repository});

  Future<TransactionCategory> execute(TransactionCategory category)async{
    var createdCategory = await repository.create(category);
    return createdCategory;
  }
}