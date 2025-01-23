import 'package:billy/exceptions/date_range_exception.dart';
import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';

class CreateLimitUseCase{

  final ILimitRepository limitRepository;

  CreateLimitUseCase({required this.limitRepository});

  Future<LimitModel> execute(LimitModel limit) async{

    if(limit.beginDate.isAfter(limit.endDate)){
      throw DateRangeException();
    }

    return await limitRepository.create(limit);
  }


}