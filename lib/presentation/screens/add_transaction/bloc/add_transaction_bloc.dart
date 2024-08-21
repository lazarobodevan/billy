import 'dart:async';

import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/balance/set_balance_use_case.dart';
import 'package:billy/use_cases/transaction/create_transaction_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_transaction_event.dart';

part 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {

  late final CreateTransactionUseCase _createTransactionUseCase;
  late final SetBalanceUseCase _setBalanceUseCase;

  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;

  late int amountInCents;
  late Transaction transaction;

  AddTransactionBloc(
      {required this.transactionRepository, required this.balanceRepository})
      : super(AddTransactionInitial()) {

    _setBalanceUseCase = SetBalanceUseCase(repository: balanceRepository);

    _createTransactionUseCase = CreateTransactionUseCase(
        transactionRepository: transactionRepository,
        setBalanceUseCase: _setBalanceUseCase);

    amountInCents = 0;
    transaction = Transaction.empty();

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
        transaction = transaction.copyWith(value: parsedValue);
        emit(ValueChangedState(value: parsedValue));
      }
    });

    on<ChangeTransactionType>((event, emit) {
      transaction = transaction.copyWith(type: event.transactionType);

      if (transaction.type == TransactionType.INCOME) {
        transaction = transaction.copyWith(isPaid: null, endDate: null);
      }

      emit(TransactionTypeChangedState(transactionType: transaction.type));
    });

    on<ChangePaymentMethod>((event, emit) {
      transaction.paymentMethod = event.paymentMethod;
      emit(PaymentMethodChangedState(paymentMethod: transaction.paymentMethod));
    });

    on<ChangeCategoryEvent>((event, emit) {
      transaction = transaction.copyWith(category: event.category);
      emit(TransactionCategoryChangedState(category: event.category));
    });

    on<ChangeTransactionDateEvent>((event, emit) {
      transaction = transaction.copyWith(date: event.date);
      //TODO: Add emit state
    });

    on<ChangeTransactionEndDateEvent>((event, emit) {
      transaction = transaction.copyWith(endDate: event.date);
      //TODO: Add emit state
    });

    on<ChangeTransactionIsPaidEvent>((event, emit) {
      transaction = transaction.copyWith(isPaid: event.isPaid);
      //TODO: Add emit state
    });

    on<ChangeTransactionNameEvent>((event, emit) {
      transaction = transaction.copyWith(name: event.name);
      emit(TransactionNameChangedState(name: event.name));
    });

    on<SaveTransactionToDatabaseEvent>((event, emit) async {
      emit(SavingTransactionToDatabaseState());
      final createdTransaction =
          await _createTransactionUseCase.execute(transaction);
      emit(SavedTransactionToDatabaseState(transaction: createdTransaction));
    });
  }
}
