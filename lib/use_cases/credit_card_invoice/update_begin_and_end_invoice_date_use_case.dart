import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';

class UpdateBeginAndEndInvoiceDateUseCase{
  final ICreditCardInvoicesRepository invoicesRepository;

  const UpdateBeginAndEndInvoiceDateUseCase({required this.invoicesRepository});

  Future<void> execute(CreditCardInvoiceModel invoice) async{
    final previousInvoice = await invoicesRepository.getPreviousInvoice(invoice.beginDate);
    final nextInvoice = await invoicesRepository.getNextInvoice(invoice.endDate);



  }
}