import 'package:billy/repositories/limit/i_limit_repository.dart';

class DeleteLimitUseCase{
  final ILimitRepository limitRepository;

  const DeleteLimitUseCase({required this.limitRepository});

  Future<void> execute(int id) async{
    await limitRepository.delete(id);
  }

}