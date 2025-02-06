import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/services/pdf_extractor_service/i_pdf_service.dart';

class SicoobPdfExtractor implements IPdfService{
  @override
  Future<List<Transaction>> getTransactionsFromCreditInvoice() {
    // TODO: implement getTransactionsFromCreditInvoice
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getTransactionsFromExtract() {
    // TODO: implement getTransactionsFromExtract
    throw UnimplementedError();
  }

}