import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/repositories/subcategory/i_subcategory_repository.dart';

class CreateSubcategoryUseCase{
  final ISubcategoryRepository repository;

  const CreateSubcategoryUseCase({required this.repository});

  Future<Subcategory> execute(Subcategory subcategory)async{
    var createdCategory = await repository.create(subcategory);
    return createdCategory;
  }
}