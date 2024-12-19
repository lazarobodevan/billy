import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/get_or_create_credit_card_invoice_to_transaction.dart';
import 'package:billy/utils/date_utils.dart';

import '../../models/transaction/transaction_model.dart';

class UpdateTransactionUseCase {
  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;
  final ICreditCardInvoicesRepository invoicesRepository;

  const UpdateTransactionUseCase(
      {required this.transactionRepository,
      required this.invoicesRepository,
      required this.balanceRepository});

  Future<Transaction> execute(Transaction transaction) async {
    final oldTransaction = await transactionRepository.getById(transaction.id!);
    var accountBalance = await balanceRepository.getBalance();
    var _transaction = transaction.copyWith();

    var changedPaymentMethod =
        transaction.paymentMethod != oldTransaction!.paymentMethod;
    var changedTransactionType = transaction.type != oldTransaction.type;
    var changedTransactionDate = oldTransaction.date != transaction.date;

    //On update paymentMethod
    if (changedPaymentMethod) {
      await _onChangedPaymentMethod(oldTransaction, _transaction, accountBalance);
    }

    //On update transaction type
    if (changedTransactionType) {
      await _onChangedTransactionType(oldTransaction, _transaction, accountBalance);
    }

    if(changedTransactionDate && transaction.paymentMethod == PaymentMethod.CREDIT_CARD){
      _onChangedTransactionDate(oldTransaction, _transaction, accountBalance);
    }

    //Update transaction
    final newTransaction = await transactionRepository.update(_transaction);
    return newTransaction;
  }

  Future<Transaction> _onChangedPaymentMethod(Transaction oldTransaction, Transaction transaction, Balance accountBalance) async {

    var _transaction = transaction.copyWith();

    if (transaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
      //Update account balance and get or create invoice
      var newBalanceTotal = accountBalance.balance >= 0
          ? accountBalance.balance - transaction.value
          : accountBalance.balance + transaction.value;

      await balanceRepository.setBalance(newBalanceTotal);
      final invoice = await GetOrCreateCreditCardInvoiceToTransaction(
          invoicesRepository: invoicesRepository)
          .execute(transaction);
      _transaction = _transaction.copyWith(
          invoice: invoice, type: TransactionType.EXPENSE);

      //Update invoice total and credit card limit used
      var newInvoiceTotal = accountBalance.limitUsed + transaction.value;
      await balanceRepository.setCreditLimitUsed(newInvoiceTotal);
      await invoicesRepository.updateTotal(invoice.id!, newInvoiceTotal);

      //If changed FROM CREDIT_CARD
    } else if (oldTransaction.paymentMethod == PaymentMethod.CREDIT_CARD) {
      //Update account balance
      var newBalanceTotal = accountBalance.balance >= 0
          ? accountBalance.balance - transaction.value
          : accountBalance.balance + transaction.value;

      await balanceRepository.setBalance(newBalanceTotal);
      _transaction =
          _transaction.copyWith(invoice: CreditCardInvoiceModel.empty());

      //Update invoice total and credit card limit used
      var newInvoiceTotal = accountBalance.limitUsed - transaction.value;
      await balanceRepository.setCreditLimitUsed(newInvoiceTotal);
      await invoicesRepository.updateTotal(
          oldTransaction.invoice!.id!, newInvoiceTotal);
    }

    return _transaction;
  }

  Future<void> _onChangedTransactionType(Transaction oldTransaction, Transaction transaction, Balance accountBalance) async{

    // If transaction type is not CREDIT_CARD, then update balance
    if (transaction.paymentMethod != PaymentMethod.CREDIT_CARD) {
      var newBalanceTotal = accountBalance.balance;

      // Desfazer o valor da transação antiga
      if (oldTransaction.type == TransactionType.INCOME) {
        newBalanceTotal -= oldTransaction.value;
      } else if (oldTransaction.type == TransactionType.EXPENSE) {
        newBalanceTotal += oldTransaction.value;
      }

      // Aplicar o valor da nova transação
      if (transaction.type == TransactionType.INCOME) {
        newBalanceTotal += transaction.value;
      } else if (transaction.type == TransactionType.EXPENSE) {
        newBalanceTotal -= transaction.value;
      }

      await balanceRepository.setBalance(newBalanceTotal);
    }
  }

  Future<Transaction> _onChangedTransactionDate(Transaction oldTransaction, Transaction transaction, Balance accountBalance) async{

    var _transaction = transaction.copyWith();
    var hasInvoiceInOldTransaction = oldTransaction.invoice != null && oldTransaction.invoice!.id != null;

    final invoice = await GetOrCreateCreditCardInvoiceToTransaction(
        invoicesRepository: invoicesRepository)
        .execute(_transaction);

    if(hasInvoiceInOldTransaction) {
      if (invoice.id != _transaction.invoice!.id) {
        var oldInvoice = await invoicesRepository.getById(oldTransaction.invoice!.id!);
        var oldInvoiceNewTotal = oldInvoice.total - oldTransaction.value;
        await invoicesRepository.updateTotal(oldInvoice.id!, oldInvoiceNewTotal);
      }
    }

    final mostRecentInvoice = await invoicesRepository.getMostRecent();

    if(MyDateUtils.isDateBetween(targetDate: _transaction.date, startDate: mostRecentInvoice.beginDate, endDate: mostRecentInvoice.endDate)){
      final balance = await balanceRepository.getBalance();
      var newLimitUsed = balance.limitUsed + _transaction.value;
      await balanceRepository.setCreditLimitUsed(newLimitUsed);
    }

    _transaction = _transaction.copyWith(
        invoice: invoice, type: TransactionType.EXPENSE);


    return _transaction;
  }
}
