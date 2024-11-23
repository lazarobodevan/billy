import 'dart:async';

import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/transaction/delete_transaction_use_case.dart';
import 'package:billy/use_cases/transaction/get_all_transactions_use_case.dart';
import 'package:billy/use_cases/transaction/get_available_periods_use_case.dart';
import 'package:billy/use_cases/transaction/list_transactions_by_date_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_transactions_event.dart';
part 'list_transactions_state.dart';

class ListTransactionsBloc extends Bloc<ListTransactionsEvent, ListTransactionsState> {

  final ITransactionRepository transactionRepository;
  late final BalanceRepository balanceRepository;
  late final GetAvailablePeriodsUseCase getAvailablePeriodsUseCase;
  late final GetAllTransactionsUseCase getAllTransactionsUseCase;
  late final ListTransactionsByDateUseCase listTransactionsByDateUseCase;
  late final DeleteTransactionUseCase deleteTransactionUseCase;

  late List<String> periods;
  late Map<DateTime,List<Transaction>> transactions;

  ListTransactionsBloc({required this.transactionRepository, required this.balanceRepository}) : super(ListTransactionsInitial()) {

    getAllTransactionsUseCase = GetAllTransactionsUseCase(transactionRepository: transactionRepository);
    getAvailablePeriodsUseCase = GetAvailablePeriodsUseCase(transactionRepository: transactionRepository);
    deleteTransactionUseCase = DeleteTransactionUseCase(transactionRepository: transactionRepository, balanceRepository: balanceRepository);
    listTransactionsByDateUseCase = ListTransactionsByDateUseCase(transactionRepository: transactionRepository);

    periods = [];
    transactions = {};

    on<ListTransactionsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadTransactionsEvent>((event, emit) async{
      emit(LoadingTransactionsDataState());
      transactions = await listTransactionsByDateUseCase.execute();
      emit(LoadedTransactionsDataState(periods: periods, transactions: transactions));

    });

    on<DeleteTransactionEvent>((event, emit) async {
      emit(LoadingTransactionsDataState());
      await deleteTransactionUseCase.execute(event.id);
      // Remover a transação da lista agrupada por data
      transactions.forEach((date, transList) {
        transList.removeWhere((t) => t.id == event.id);
      });
      // Remover qualquer data que não tenha mais transações
      transactions.removeWhere((date, transList) => transList.isEmpty);
      emit(LoadedTransactionsDataState(periods: periods, transactions: transactions));
    });


  }
}
