import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';

class GetCreditCardInvoicesUseCase{
  final ICreditCardInvoicesRepository creditCardInvoicesRepository;

  GetCreditCardInvoicesUseCase({required this.creditCardInvoicesRepository});
  
  Future<List<CreditCardInvoiceModel>> execute() async{
    return await creditCardInvoicesRepository.get();
  }
  
}