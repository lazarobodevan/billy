import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';

class CreateLimitUseCase{

  final ILimitRepository limitRepository;

  CreateLimitUseCase({required this.limitRepository});

  Future<LimitModel> execute(LimitModel limit) async{
    return await limitRepository.create(limit);
  }


}