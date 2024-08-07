import 'dart:async';

import 'package:billy/transaction/repository/i_transaction_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_transaction_event.dart';
part 'add_transaction_state.dart';

class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  final ITransactionRepository transactionRepository;
  int amountInCents = 0;  // Armazena o valor em centavos

  AddTransactionBloc({required this.transactionRepository}) : super(AddTransactionInitial()) {

    on<ResetValue>((event, emit){
      amountInCents = 0;
      emit(const ValueChangedState(value: 0));
    });

    on<TriggerValue>((event, emit) {
      amountInCents = amountInCents * 10 + event.value;
      double parsedValue = amountInCents / 100.0;
      emit(ValueChangedState(value: parsedValue));
    });

    on<EraseValue>((event, emit) {
      if (amountInCents != 0) {
        amountInCents ~/= 10;
        double parsedValue = amountInCents / 100.0;
        emit(ValueChangedState(value: parsedValue));
      }
    });
  }
}
