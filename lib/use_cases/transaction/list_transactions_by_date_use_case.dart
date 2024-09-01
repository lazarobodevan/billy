import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class ListTransactionsByDateUseCase{

  final ITransactionRepository transactionRepository;

  const ListTransactionsByDateUseCase({required this.transactionRepository});

  Future<Map<DateTime, List<Transaction>>> execute({int limit = 10, int offset = 0}) async{
    return await transactionRepository.getAllGroupedByDate(limit: limit, offset: offset);
  }

}