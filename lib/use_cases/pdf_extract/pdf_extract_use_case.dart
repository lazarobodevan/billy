import 'dart:io';

import 'package:billy/enums/bank/bank_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/services/file_service/i_file_service.dart';
import 'package:billy/services/pdf_extractor_service/i_pdf_service.dart';
import 'package:billy/services/pdf_extractor_service/impl/sicoob_pdf_extractor.dart';

class PdfExtractUseCase{

  final IFileService fileService;

  PdfExtractUseCase({required this.fileService});

  Future<List<Transaction>> execute({required BankType bankType, required bool isInvoice}) async {
    IPdfService pdfService = getPdfService(bankType);
    List<Transaction> transactions = [];

    File? file = await fileService.openFile();

    if(file == null){
      return [];
    }

    if(isInvoice){
      transactions = await pdfService.getTransactionsFromCreditInvoice(file);
    }else{
      transactions = await pdfService.getTransactionsFromExtract(file);
    }

    return transactions;

  }

  IPdfService getPdfService(BankType bankType){
    switch(bankType){
      case BankType.SICOOB:{
        return SicoobPdfExtractor();
      }
    }
  }



}