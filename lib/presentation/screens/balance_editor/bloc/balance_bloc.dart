import 'dart:async';

import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/use_cases/balance/get_balance_use_case.dart';
import 'package:billy/use_cases/balance/set_balance_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  final BalanceRepository balanceRepository;
  final ICreditCardInvoicesRepository invoicesRepository;
  late final GetBalanceUseCase getBalanceUseCase;
  late final SetBalanceUseCase setBalanceUseCase;

  BalanceBloc({required this.balanceRepository, required this.invoicesRepository}) : super(BalanceInitial()) {

    getBalanceUseCase = GetBalanceUseCase(repository: balanceRepository);
    setBalanceUseCase = SetBalanceUseCase(repository: balanceRepository, creditCardInvoiceRepository: invoicesRepository);

    on<LoadBalanceEvent>((event, emit)async{
      emit(LoadingBalanceState());
      var balance = await getBalanceUseCase.execute();
      emit(LoadedBalanceState(balance: balance));
    });

    on<UpdateBalanceEvent>((event, emit) async {
      emit(UpdatingBalanceState());
      await setBalanceUseCase.override(event.balance);
      emit(UpdatedBalanceState());
    });
  }
}
