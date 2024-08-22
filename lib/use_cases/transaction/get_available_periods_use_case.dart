import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class GetAvailablePeriodsUseCase{
  final ITransactionRepository transactionRepository;

  GetAvailablePeriodsUseCase({required this.transactionRepository});

  Future<List<String>> execute() async{
    final periods = await transactionRepository.getAvailablePeriods();
    return periods;
  }
}