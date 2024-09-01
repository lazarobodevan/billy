import 'dart:async';

import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/balance/set_balance_use_case.dart';
import 'package:billy/use_cases/transaction/create_transaction_use_case.dart';
import 'package:billy/use_cases/transaction/get_all_transactions_use_case.dart';
import 'package:billy/use_cases/transaction/get_available_periods_use_case.dart';
import 'package:billy/use_cases/transaction/update_transaction_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ITransactionRepository transactionRepository;
  final IBalanceRepository balanceRepository;

  //Add new transaction variables
  late final CreateTransactionUseCase _createTransactionUseCase;
  late final SetBalanceUseCase _setBalanceUseCase;

  late int amountInCents;
  late Transaction transaction;

  //List transactions variables
  late final GetAvailablePeriodsUseCase _getAvailablePeriodsUseCase;
  late final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  late final UpdateTransactionUseCase _updateTransactionUseCase;

  late List<String> periods;
  late List<Transaction> transactions;

  TransactionBloc(
      {required this.transactionRepository, required this.balanceRepository})
      : super(TransactionInitial()) {

    //****** USE CASES *******
    _setBalanceUseCase = SetBalanceUseCase(repository: balanceRepository);
    _createTransactionUseCase = CreateTransactionUseCase(
        transactionRepository: transactionRepository,
        setBalanceUseCase: _setBalanceUseCase);
    _updateTransactionUseCase = UpdateTransactionUseCase(transactionRepository: transactionRepository);

    //****** VARIABLES *******
    amountInCents = 0;
    transaction = Transaction.empty();
    periods = [];
    transactions = [];

    on<TransactionValueDigitChangedEvent>((event, emit) {
      amountInCents = amountInCents * 10 + event.value;
      double parsedValue = amountInCents / 100.0;
      transaction.value = parsedValue;
      emit(ValueChangedState(value: parsedValue));
    });

    on<TransactionValueChangedEvent>((event, emit) {
      final newValue = double.tryParse(event.value.replaceAll(',', '.').replaceAll("R\$", "")) ?? 0.0;
      amountInCents = (newValue * 100).round();
      transaction.value = newValue;
      emit(ValueChangedState(value: newValue));
    });

    on<ResetTransaction>((event, emit){
      amountInCents = 0;
      transaction = Transaction.empty();
      periods = [];
      transactions = [];
      emit(TransactionInitial());
    });

    on<EraseValue>((event, emit) {
      if (amountInCents != 0) {
        amountInCents ~/= 10;
        double parsedValue = amountInCents / 100.0;
        transaction = transaction.copyWith(value: parsedValue);
        emit(ValueChangedState(value: parsedValue));
      }
    });

    on<SetTransactionEvent>((event, emit) {
      emit(ValueChangedState(value: 0));
      transaction = event.transaction.copyWith();
      amountInCents = (transaction.value * 100).toInt();
      emit(TransactionInitial());
    });

    on<TransactionTypeChangedEvent>((event, emit) {
      transaction = transaction.copyWith(type: event.transactionType);

      if (transaction.type == TransactionType.INCOME) {
        transaction = transaction.copyWith(isPaid: null, endDate: null);
      }

      emit(TransactionTypeChangedState(transactionType: transaction.type));
    });

    on<TransactionPaymentMethodChangedEvent>((event, emit) {
      transaction.paymentMethod = event.paymentMethod;
      emit(PaymentMethodChangedState(paymentMethod: transaction.paymentMethod));
    });

    on<TransactionCategoryChangedEvent>((event, emit) {
      transaction = transaction.copyWith(category: event.category);
      emit(TransactionCategoryChangedState(category: event.category));
    });

    on<TransactionDateChangedEvent>((event, emit) {
      transaction = transaction.copyWith(date: event.date);
      //TODO: Add emit state
    });

    on<TransactionEndDateChangedEvent>((event, emit) {
      transaction = transaction.copyWith(endDate: event.date);
      //TODO: Add emit state
    });

    on<TransactionIsPaidChangedEvent>((event, emit) {
      transaction = transaction.copyWith(isPaid: event.isPaid);
      emit(TransactionIsPaidChangedState(isPaid: transaction.isPaid!));
    });

    on<TransactionNameChangedEvent>((event, emit) {
      transaction = transaction.copyWith(name: event.name);
      emit(TransactionNameChangedState(name: event.name));
    });

    on<SaveTransactionToDatabaseEvent>((event, emit) async {
      emit(SavingTransactionToDatabaseState());
      final createdTransaction =
          await _createTransactionUseCase.execute(transaction);
      emit(SavedTransactionToDatabaseState(transaction: createdTransaction));
    });

    on<UpdateTransactionToDatabaseEvent>((event, emit) async{
      emit(SavingTransactionToDatabaseState());
      final updated = await _updateTransactionUseCase.execute(transaction);
      emit(SavedTransactionToDatabaseState(transaction: updated));
    });
  }
}
