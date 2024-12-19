import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/get_or_create_credit_card_invoice_to_transaction.dart';
import 'package:billy/utils/date_utils.dart';

import '../../repositories/balance/i_balance_repository.dart';
import '../balance/set_balance_use_case.dart';

class CreateTransactionUseCase {
  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;
  final ICreditCardInvoicesRepository creditCardInvoiceRepository;

  CreateTransactionUseCase(
      {required this.transactionRepository,
      required this.creditCardInvoiceRepository,
      required this.balanceRepository});

  Future<Transaction> execute(Transaction transaction) async {
    final SetBalanceUseCase setBalanceUseCase = SetBalanceUseCase(
        repository: balanceRepository,
        creditCardInvoiceRepository: creditCardInvoiceRepository);

    var getOrCreateCreditCardInvoiceToTransaction =
        GetOrCreateCreditCardInvoiceToTransaction(
            invoicesRepository: creditCardInvoiceRepository);

    Transaction _transaction = transaction;

    late CreditCardInvoiceModel invoice;
    if (transaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
      invoice =
          await getOrCreateCreditCardInvoiceToTransaction.execute(transaction);
      _transaction = _transaction.copyWith(invoice: invoice);
    }

    var createdTransaction = await transactionRepository.create(_transaction);

    if (transaction.type == TransactionType.EXPENSE) {
      if (transaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
        final balance = await balanceRepository.getBalance();

        final newInvoiceTotal = invoice.total + transaction.value;

        await creditCardInvoiceRepository.updateTotal(
            _transaction.invoice!.id!, newInvoiceTotal);

        final mostRecentInvoice =
            await creditCardInvoiceRepository.getMostRecent();
        if (MyDateUtils.isDateBetween(
            targetDate: _transaction.date,
            startDate: mostRecentInvoice.beginDate,
            endDate: mostRecentInvoice.endDate)) {
          final newBalance = balance.limitUsed + _transaction.value;
          await balanceRepository.setCreditLimitUsed(newBalance);
        }
      } else {
        // Pix or money
        final balance = await balanceRepository.getBalance();
        final newBalance = balance.balance - transaction.value;

        await balanceRepository.setBalance(newBalance);
      }
    } else {
      // Income
      final balance = await balanceRepository.getBalance();
      final newBalance = balance.balance + transaction.value;

      await balanceRepository.setBalance(newBalance);
    }

    return createdTransaction;
  }
}
