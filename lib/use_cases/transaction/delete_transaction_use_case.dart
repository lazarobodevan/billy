import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class DeleteTransactionUseCase {
  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;

  const DeleteTransactionUseCase(
      {required this.transactionRepository, required this.balanceRepository});

  Future<void> execute(int id) async {
    final foundTransaction = await transactionRepository.getById(id);
    if (foundTransaction == null) return;

    await transactionRepository.delete(id);
    var balance = await balanceRepository.getBalance();

    if (foundTransaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
      await balanceRepository
          .setCreditLimitUsed(balance.limitUsed - foundTransaction.value);
    } else {
      final newBalance = balance.balance > 0 ? balance.balance -
          foundTransaction.value : balance.balance + foundTransaction.value;
      await balanceRepository
          .setBalance(newBalance);
    }
  }
}
