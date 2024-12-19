import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';

class CreateCreditCardInvoiceUseCase{
  final ICreditCardInvoicesRepository creditCardInvoicesRepository;

  CreateCreditCardInvoiceUseCase({required this.creditCardInvoicesRepository});

  Future<CreditCardInvoiceModel> execute(CreditCardInvoiceModel invoice) async{
    return await creditCardInvoicesRepository.create(invoice);
  }
}