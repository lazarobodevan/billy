import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';

abstract class ICreditCardInvoicesRepository{

  Future<CreditCardInvoiceModel> create(CreditCardInvoiceModel invoice);
  Future<CreditCardInvoiceModel> update(CreditCardInvoiceModel invoice);
  Future<void> updateTotal(int id, double total);
  Future<List<CreditCardInvoiceModel>> get({int? limit});
  Future<CreditCardInvoiceModel> getById(int id);
  Future<CreditCardInvoiceModel> getMostRecent();
  Future<CreditCardInvoiceModel?> getByBeginDate(DateTime date);
  Future<CreditCardInvoiceModel?> getPreviousInvoice(DateTime date);
  Future<CreditCardInvoiceModel?> getNextInvoice(DateTime date);

}
