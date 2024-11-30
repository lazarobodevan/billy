import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';

class ListLimitsUseCase{
  final ILimitRepository limitRepository;

  ListLimitsUseCase({required this.limitRepository});

  Future<List<LimitModel>> execute() async{
    return await limitRepository.getAll();
  }

  Future<LimitModel?> executeById(int id) async{
    return await limitRepository.getById(id);
  }

}