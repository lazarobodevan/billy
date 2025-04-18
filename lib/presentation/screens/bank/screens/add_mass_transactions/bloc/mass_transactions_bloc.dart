import 'package:billy/enums/bank/bank_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/services/file_service/i_file_service.dart';
import 'package:billy/use_cases/pdf_extract/pdf_extract_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mass_transactions_event.dart';

part 'mass_transactions_state.dart';

class MassTransactionsBloc
    extends Bloc<MassTransactionsEvent, MassTransactionsState> {

  final IFileService fileService;
  List<Transaction> transactions = [];

  MassTransactionsBloc({required this.fileService})
      : super(MassTransactionsInitial()) {

    on<MassTransactionsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadMassTransactionsEvent>((event, emit) async {
      try {
        emit(LoadingMassTransactionsState());

        transactions = [];
        final PdfExtractUseCase extractUseCase =
            PdfExtractUseCase(fileService: fileService);

        transactions = await extractUseCase.execute(
            bankType: event.bankType, isInvoice: event.isInvoice);

        emit(LoadedMassTransactionsState(transactions: transactions));

      } catch (e) {
        emit(LoadMassTransactionsErrorState(message: e.toString()));
      }
    });
  }
}
