import 'package:billy/repositories/transaction/i_transaction_repository.dart';

import '../../models/transaction/transaction_model.dart';

class UpdateTransactionUseCase{
  final ITransactionRepository transactionRepository;

  const UpdateTransactionUseCase({required this.transactionRepository});

  Future<Transaction> execute(Transaction transaction)async{
    final newTransaction = await transactionRepository.update(transaction);
    return newTransaction;
  }


}