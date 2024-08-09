import 'package:billy/repositories/category/i_category_repository.dart';

class DeleteCategoryUseCase{
  final ICategoryRepository repository;

  const DeleteCategoryUseCase({required this.repository});

  Future<void> execute(int id)async{
    final foundCategory = await repository.getById(id);

    if(foundCategory == null){
      throw Exception("Categoria não existe");
    }

    await repository.delete(id);
  }
}