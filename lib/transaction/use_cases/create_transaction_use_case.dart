import 'package:billy/transaction/models/transaction_model.dart';
import 'package:billy/transaction/repository/i_transaction_repository.dart';

class CreateTransactionUseCase{
  final ITransactionRepository transactionRepository;

  CreateTransactionUseCase({required this.transactionRepository});

  Future<Transaction> execute(Transaction transaction) async{
    var createdTransaction = await transactionRepository.create(transaction);
    return createdTransaction;
  }
}