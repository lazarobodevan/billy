import 'dart:io';

import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/services/file_service/i_file_service.dart';
import 'package:billy/services/pdf_extractor_service/i_pdf_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SicoobPdfExtractor implements IPdfService {

  @override
  Future<List<Transaction>> getTransactionsFromCreditInvoice(File file) async {

    final List<int> bytes = await file.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final String text = PdfTextExtractor(document).extractText();

    document.dispose();

    //Regex to capture the invoice year
    final RegExp regexDate = RegExp(r'Vencimento:\s+\d{2}/\d{2}/(\d{4})');
    final Match? matchDate = regexDate.firstMatch(text);

    //Regular expression to capture Data \n Comercio \n Valor
    final RegExp regexData = RegExp(
      r'(\d{2}/\d{2})\s+((?:[^\d\n]+\n?)+?)\s+(-?\d{1,3}(?:\.\d{3})*,\d{2})',
      multiLine: true,
    );

    final matches = regexData.allMatches(text);
    List<Transaction> transactions = [];

    if (matchDate == null) {
      throw Exception("Não foi possível encontrar a data da fatura");
    }

    final String invoiceYear = matchDate.group(1)!;

    for (final match in matches) {
      String dateStr = match.group(1)!;
      String store = match.group(2)!;
      String valueStr = match.group(3)!;
      double value = double.parse(valueStr.replaceAll(".", "").replaceAll(",", "."));

      // Remover quebras de linha e espaços extras do nome do comércio
      store = store.replaceAll("\n", " ").trim();

      //Ignore PAGAMENTO-BOLETO BANCARIO
      if(store.toUpperCase() == "PAGAMENTO-BOLETO BANCARIO"){
        continue;
      }

      final List<String> dateParts = dateStr.split("/");
      final int day = int.parse(dateParts[0]);
      final int month = int.parse(dateParts[1]);
      final int year = int.parse(invoiceYear);

      final DateTime date = DateTime(year, month, day);

      transactions.add(Transaction(
          description: store,
          value: value,
          category: null,
          type: TransactionType.EXPENSE,
          paymentMethod: PaymentMethod.CREDIT_CARD,
          date: date));
    }

    return transactions;
  }

  @override
  Future<List<Transaction>> getTransactionsFromExtract(File file) {
    // TODO: implement getTransactionsFromExtract
    throw UnimplementedError();
  }
}
