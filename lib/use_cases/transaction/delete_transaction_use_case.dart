import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/utils/date_utils.dart';

class DeleteTransactionUseCase {
  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;
  final ICreditCardInvoicesRepository invoicesRepository;

  const DeleteTransactionUseCase(
      {required this.transactionRepository,
      required this.balanceRepository,
      required this.invoicesRepository});

  Future<void> execute(int id) async {
    final foundTransaction = await transactionRepository.getById(id);
    if (foundTransaction == null) return;

    await transactionRepository.delete(id);
    var balance = await balanceRepository.getBalance();

    if (foundTransaction.paymentMethod == PaymentMethod.CREDIT_CARD) {

      final invoice = await invoicesRepository.getById(foundTransaction.invoice!.id!);
      var newInvoiceTotal = invoice.total - foundTransaction.value;
      await invoicesRepository.updateTotal(foundTransaction.invoice!.id!, newInvoiceTotal);

      if(MyDateUtils.isDateBetween(targetDate: DateTime.now(), startDate: invoice.beginDate, endDate: invoice.endDate)){
        var newLimitUsed = balance.limitUsed - foundTransaction.value;
        await balanceRepository
            .setCreditLimitUsed(newLimitUsed >= 0 ? newLimitUsed : 0);
      }
    } else {

      final newBalance = balance.balance > 0
          ? balance.balance - foundTransaction.value
          : balance.balance + foundTransaction.value;

      await balanceRepository.setBalance(newBalance);
    }
  }
}
