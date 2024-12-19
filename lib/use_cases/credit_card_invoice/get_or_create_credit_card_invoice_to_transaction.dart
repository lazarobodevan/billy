import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/create_credit_card_invoice_use_case.dart';
import 'package:billy/utils/date_utils.dart';
import 'package:flutter/material.dart';

class GetOrCreateCreditCardInvoiceToTransaction {
  final ICreditCardInvoicesRepository invoicesRepository;

  const GetOrCreateCreditCardInvoiceToTransaction({
    required this.invoicesRepository,
  });

  Future<CreditCardInvoiceModel> execute(Transaction transaction) async {

    CreateCreditCardInvoiceUseCase createCreditCardInvoiceUseCase =
        CreateCreditCardInvoiceUseCase(
            creditCardInvoicesRepository: invoicesRepository);

    var mostRecent = await invoicesRepository.getMostRecent();

    /*
    * If the transaction date is between the begin and end of the most
    * recent invoice, then it is in the current invoice.
     */
    if (MyDateUtils.isDateBetween(
        targetDate: transaction.date,
        startDate: mostRecent.beginDate,
        endDate: mostRecent.endDate)) {
      return mostRecent;
    }

    final respectiveTransaction = await invoicesRepository.getByBeginDate(transaction.date);

    if(respectiveTransaction != null){
      return respectiveTransaction;
    }

    /*
    * If the transaction date is after the most recent invoice then
    * a new invoice must be created.
     */
    if (transaction.date.isAfter(mostRecent.beginDate)) {
      CreditCardInvoiceModel invoiceModel = CreditCardInvoiceModel(
          id: 0,
          total: 0,
          beginDate: mostRecent.endDate.add(const Duration(days: 1)),
          endDate: mostRecent.endDate.add(const Duration(days: 30)));

      var createdInvoice =
          await createCreditCardInvoiceUseCase.execute(invoiceModel);
      return createdInvoice;
    } else {
      /*
      * Otherwise, if the transaction date is before the most recent invoice
      * then a previous invoice must be updated. Also, if there is no invoice
      * in the period, then it has to be created.
      *
      * If there is a previous invoice, the new invoice begin date must be one
      * day after this previous end date. Otherwise, If there is no previous
      * invoice, then the new invoice begin date must be the first day of the
      * transaction month.
      *
      * If there is a next invoice, the new invoice end date must be one day
      * before this next begin date. Otherwise, if there is no next invoice,
      * then the new invoice end date must be the last day of the transaction
      * month.
       */

      var previousInvoice =
          await invoicesRepository.getPreviousInvoice(transaction.date);
      var nextInvoice =
          await invoicesRepository.getNextInvoice(transaction.date);

      DateTime beginDate;
      DateTime endDate;

      // Define o beginDate
      if (previousInvoice != null) {
        beginDate = previousInvoice.endDate.add(const Duration(days: 1));
      } else {
        // Primeiro dia do mês da transação
        beginDate = DateTime(transaction.date.year, transaction.date.month, 1);
      }

      // Define o endDate
      if (nextInvoice != null) {
        endDate = nextInvoice.beginDate.subtract(const Duration(days: 1));
      } else {
        // Último dia do mês da transação
        endDate =
            DateTime(transaction.date.year, transaction.date.month + 1, 0);
      }

      // Cria nova fatura com base nas datas definidas
      CreditCardInvoiceModel invoiceModel = CreditCardInvoiceModel(
        total: 0,
        beginDate: beginDate,
        endDate: endDate,
      );

      var createdInvoice =
          await createCreditCardInvoiceUseCase.execute(invoiceModel);
      return createdInvoice;
    }
  }
}
