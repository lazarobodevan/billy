import '../../repositories/subcategory/i_subcategory_repository.dart';

class DeleteSubcategoryUseCase{
  final ISubcategoryRepository repository;

  const DeleteSubcategoryUseCase({required this.repository});

  Future<void> execute(int id)async{
    final foundCategory = await repository.getById(id);

    if(foundCategory == null){
      throw Exception("Subcategoria não existe");
    }

    await repository.delete(id);
  }
}