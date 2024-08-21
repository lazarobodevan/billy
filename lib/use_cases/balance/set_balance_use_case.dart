import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';

class SetBalanceUseCase {
  final IBalanceRepository repository;

  SetBalanceUseCase({required this.repository});

  Future<double> execute(Transaction transaction) async {
    if (transaction.type == TransactionType.EXPENSE) {
      if (transaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
        final balance = await repository.getBalance();
        final newBalance = balance.limitUsed + transaction.value;

        return await repository.setCreditLimitUsed(newBalance);
      }

      // Pix or money
      final balance = await repository.getBalance();
      final newBalance = balance.balance - transaction.value;

      return await repository.setBalance(newBalance);
    }

    // Income
    final balance = await repository.getBalance();
    final newBalance = balance.balance + transaction.value;

    return await repository.setBalance(newBalance);
  }
}
