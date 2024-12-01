import 'dart:async';

import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';
import 'package:billy/use_cases/balance/get_balance_use_case.dart';
import 'package:billy/use_cases/limit/list_limits_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../models/balance/balance_model.dart';
import '../../../../../models/transaction/transaction_model.dart';
import '../../../../../repositories/transaction/i_transaction_repository.dart';
import '../../../../../use_cases/transaction/get_all_transactions_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  late final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  late final GetBalanceUseCase _getBalanceUseCase;
  late final ListLimitsUseCase _listLimitsUseCase;

  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;
  final ILimitRepository limitRepository;

  late final List<Transaction> _transactions;


  HomeBloc(
      {required this.transactionRepository, required this.balanceRepository, required this.limitRepository})
      : super(HomeInitial()) {

    _getAllTransactionsUseCase =
        GetAllTransactionsUseCase(transactionRepository: transactionRepository);
    _getBalanceUseCase = GetBalanceUseCase(repository: balanceRepository);
    _listLimitsUseCase = ListLimitsUseCase(limitRepository: limitRepository);
    _transactions = [];

    on<LoadHomeEvent>((event, emit) async {
      emit(LoadingHomeState());
      final balance = await _getBalanceUseCase.execute();
      final limits = await _listLimitsUseCase.execute();
      emit(LoadedHomeState(limits: limits, balance: balance));
    });
  }
}
