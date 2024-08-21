import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

import '../../repositories/balance/i_balance_repository.dart';
import '../balance/set_balance_use_case.dart';

class CreateTransactionUseCase{
  final ITransactionRepository transactionRepository;
  final SetBalanceUseCase setBalanceUseCase;

  CreateTransactionUseCase({required this.transactionRepository, required this.setBalanceUseCase});

  Future<Transaction> execute(Transaction transaction) async{
    var createdTransaction = await transactionRepository.create(transaction);
    await setBalanceUseCase.execute(transaction);
    return createdTransaction;
  }
}