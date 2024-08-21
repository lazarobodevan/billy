import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';

class GetBalanceUseCase{
  final IBalanceRepository repository;

  GetBalanceUseCase({required this.repository});

  Future<Balance> execute() async{
    return await repository.getBalance();
  }

}