import 'package:billy/models/transaction/transaction_model.dart';

abstract class IPdfService{

  Future<List<Transaction>> getTransactionsFromExtract();
  Future<List<Transaction>> getTransactionsFromCreditInvoice();

}