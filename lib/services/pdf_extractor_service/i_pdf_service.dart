import 'dart:io';

import 'package:billy/models/transaction/transaction_model.dart';

abstract class IPdfService{

  Future<List<Transaction>> getTransactionsFromExtract(File file);
  Future<List<Transaction>> getTransactionsFromCreditInvoice(File file);

}