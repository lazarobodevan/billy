import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/repositories/subcategory/i_subcategory_repository.dart';

class GetAllSubcategoriesUseCase{
  final ISubcategoryRepository subcategoryRepository;

  const GetAllSubcategoriesUseCase({required this.subcategoryRepository});

  Future<List<Subcategory>> execute() async{
    return await subcategoryRepository.getAll();
  }


}