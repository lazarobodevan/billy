import 'dart:async';

import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_transaction_event.dart';

part 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  final ITransactionRepository transactionRepository;
  int amountInCents = 0;
  Transaction transaction = Transaction.empty();

  AddTransactionBloc({required this.transactionRepository})
      : super(AddTransactionInitial()) {
    on<ResetValue>((event, emit) {
      amountInCents = 0;
      transaction = Transaction.empty();
      emit(const ValueChangedState(value: 0));
    });

    on<TriggerValue>((event, emit) {
      amountInCents = amountInCents * 10 + event.value;
      double parsedValue = amountInCents / 100.0;
      transaction.value = parsedValue;
      emit(ValueChangedState(value: parsedValue));
    });

    on<EraseValue>((event, emit) {
      if (amountInCents != 0) {
        amountInCents ~/= 10;
        double parsedValue = amountInCents / 100.0;
        transaction.value = parsedValue;
        emit(ValueChangedState(value: parsedValue));
      }
    });

    on<ChangeTransactionType>((event, emit){
      transaction.type = event.transactionType;
      emit(TransactionTypeChangedState(transactionType: transaction.type));
    });

    on<ChangePaymentMethod>((event, emit){
      transaction.paymentMethod = event.paymentMethod;
      emit(PaymentMethodChangedState(paymentMethod: transaction.paymentMethod));
    });
  }
}
