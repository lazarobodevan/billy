

import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class GetAllTransactionsUseCase{
  final ITransactionRepository _transactionRepository;

  GetAllTransactionsUseCase({required ITransactionRepository transactionRepository}) : _transactionRepository = transactionRepository;

  Future<List<Transaction>> execute() async{
    var transactions = _transactionRepository.getAll();

    return transactions;
  }
}