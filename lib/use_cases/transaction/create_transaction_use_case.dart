import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class CreateTransactionUseCase{
  final ITransactionRepository transactionRepository;

  CreateTransactionUseCase({required this.transactionRepository});

  Future<Transaction> execute(Transaction transaction) async{
    var createdTransaction = await transactionRepository.create(transaction);
    return createdTransaction;
  }
}