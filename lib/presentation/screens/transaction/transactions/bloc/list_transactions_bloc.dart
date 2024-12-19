import 'dart:async';

import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/transaction/delete_transaction_use_case.dart';
import 'package:billy/use_cases/transaction/get_all_transactions_use_case.dart';
import 'package:billy/use_cases/transaction/get_available_periods_use_case.dart';
import 'package:billy/use_cases/transaction/list_transactions_by_date_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_transactions_event.dart';

part 'list_transactions_state.dart';

class ListTransactionsBloc
    extends Bloc<ListTransactionsEvent, ListTransactionsState> {
  final ITransactionRepository transactionRepository;
  late final BalanceRepository balanceRepository;
  final ICreditCardInvoicesRepository invoicesRepository;
  late final GetAvailablePeriodsUseCase getAvailablePeriodsUseCase;
  late final GetAllTransactionsUseCase getAllTransactionsUseCase;
  late final ListTransactionsByDateUseCase listTransactionsByDateUseCase;
  late final DeleteTransactionUseCase deleteTransactionUseCase;

  late List<String> periods;
  late Map<DateTime, List<Transaction>> transactions;

  ListTransactionsBloc(
      {required this.transactionRepository,
      required this.balanceRepository,
      required this.invoicesRepository})
      : super(ListTransactionsInitial()) {
    getAllTransactionsUseCase =
        GetAllTransactionsUseCase(transactionRepository: transactionRepository);
    getAvailablePeriodsUseCase = GetAvailablePeriodsUseCase(
        transactionRepository: transactionRepository);
    deleteTransactionUseCase = DeleteTransactionUseCase(
        transactionRepository: transactionRepository,
        balanceRepository: balanceRepository,
        invoicesRepository: invoicesRepository);
    listTransactionsByDateUseCase = ListTransactionsByDateUseCase(
        transactionRepository: transactionRepository);

    periods = [];
    transactions = {};
    var pageNumber = 0;
    bool _isLoadingMore = false;

    on<ListTransactionsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadTransactionsEvent>((event, emit) async {

      bool isFirstFetch = pageNumber == 0 || event.isFirstFetch == true;

      emit(LoadingTransactionsDataState(isFirstFetch: isFirstFetch));

      if(isFirstFetch){
        pageNumber = 0;
        transactions = {};
      }

      var pageTransactions = await listTransactionsByDateUseCase.execute(pageNumber: pageNumber);
      pageTransactions.forEach((date, newTransactions) {
        if (transactions.containsKey(date)) {
          transactions[date]!.addAll(newTransactions);
        } else {
          transactions[date] = newTransactions;
        }
      });
      pageNumber++;

      emit(LoadedTransactionsDataState(
          periods: periods, transactions: transactions));
    });

    on<DeleteTransactionEvent>((event, emit) async {
      emit(LoadingTransactionsDataState());

      // Remover a transação da lista agrupada por data
      transactions.forEach((date, transList) {
        transList.removeWhere((t) => t.id == event.id);
      });
      // Remover qualquer data que não tenha mais transações
      transactions.removeWhere((date, transList) => transList.isEmpty);

      await deleteTransactionUseCase.execute(event.id);

      emit(LoadedTransactionsDataState(
          periods: periods, transactions: transactions));
    });
  }
}
