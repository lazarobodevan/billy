import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';

class UpdateCategoryUseCase{
  final ICategoryRepository repository;

  const UpdateCategoryUseCase({required this.repository});

  Future<TransactionCategory> execute(TransactionCategory category)async{

    if(category.id == null){return TransactionCategory.empty();}

    final foundCategory = await repository.getById(category.id!);
    if(foundCategory == null){
      throw Exception("Categoria nao encontrada");
    }
    return await repository.update(category);
  }
}