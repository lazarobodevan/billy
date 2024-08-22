import 'dart:async';

import 'package:billy/use_cases/transaction/get_all_transactions_use_case.dart';
import 'package:billy/use_cases/transaction/get_available_periods_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../models/transaction/transaction_model.dart';
import '../../../../../repositories/transaction/i_transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {

  final ITransactionRepository transactionRepository;
  late final GetAvailablePeriodsUseCase getAvailablePeriodsUseCase;
  late final GetAllTransactionsUseCase getAllTransactionsUseCase;

  late List<String> periods;
  late List<Transaction> transactions;

  TransactionsBloc({required this.transactionRepository}) : super(TransactionsInitial()) {

    getAvailablePeriodsUseCase = GetAvailablePeriodsUseCase(transactionRepository: transactionRepository);
    getAllTransactionsUseCase = GetAllTransactionsUseCase(transactionRepository: transactionRepository);

    periods = [];
    transactions = [];

    on<LoadTransactionsDataEvent>((event, emit) async{
      emit(LoadingTransactionsDataState());
      periods = await getAvailablePeriodsUseCase.execute();
      transactions = await getAllTransactionsUseCase.execute();
      emit(LoadedTransactionsDataState(transactions: transactions, periods: periods));
    });
  }
}
