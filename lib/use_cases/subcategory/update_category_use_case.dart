import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';

import '../../repositories/subcategory/i_subcategory_repository.dart';

class UpdateCategoryUseCase{
  final ISubcategoryRepository repository;

  const UpdateCategoryUseCase({required this.repository});

  Future<Subcategory> execute(Subcategory subcategory)async{

    if(subcategory.id == null){return Subcategory.empty();}

    final foundSubcategory = await repository.getById(subcategory.id!);
    if(foundSubcategory == null){
      throw Exception("Subcategoria nao encontrada");
    }
    return await repository.update(subcategory);
  }
}