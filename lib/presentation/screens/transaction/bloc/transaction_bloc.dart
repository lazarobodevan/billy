import 'dart:async';

import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/balance/set_balance_use_case.dart';
import 'package:billy/use_cases/credit_card_invoice/get_or_create_credit_card_invoice_to_transaction.dart';
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
  final ICreditCardInvoicesRepository invoicesRepository;

  //Add new transaction variables
  late final CreateTransactionUseCase _createTransactionUseCase;
  late final SetBalanceUseCase _setBalanceUseCase;

  late int amountInCents;
  late Transaction transaction;

  //List transactions variables
  late final GetAvailablePeriodsUseCase _getAvailablePeriodsUseCase;
  late final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  late final UpdateTransactionUseCase _updateTransactionUseCase;

  //Invoice use cases
  late final GetOrCreateCreditCardInvoiceToTransaction
      _getOrCreateCreditCardInvoiceToTransaction;

  late List<String> periods;
  late List<Transaction> transactions;

  TransactionBloc(
      {required this.transactionRepository,
      required this.balanceRepository,
      required this.invoicesRepository})
      : super(TransactionInitial()) {
    //****** USE CASES *******
    _setBalanceUseCase = SetBalanceUseCase(
        repository: balanceRepository,
        creditCardInvoiceRepository: invoicesRepository);

    _getOrCreateCreditCardInvoiceToTransaction =
        GetOrCreateCreditCardInvoiceToTransaction(
            invoicesRepository: invoicesRepository);

    _createTransactionUseCase = CreateTransactionUseCase(
        transactionRepository: transactionRepository,
        balanceRepository: balanceRepository,
        creditCardInvoiceRepository: invoicesRepository);

    _updateTransactionUseCase = UpdateTransactionUseCase(
        transactionRepository: transactionRepository,
        invoicesRepository: invoicesRepository,
        balanceRepository: balanceRepository);

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
      final newValue = double.tryParse(
              event.value.replaceAll(',', '.').replaceAll("R\$", "")) ??
          0.0;
      amountInCents = (newValue * 100).round();
      transaction.value = newValue;
      emit(ValueChangedState(value: newValue));
    });

    on<ResetTransaction>((event, emit) {
      emit(TransactionInitial());
      amountInCents = 0;
      transaction = Transaction.empty();
      periods = [];
      transactions = [];
      emit(AddTransactionInitial());
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

      if(transaction.paymentMethod == PaymentMethod.CREDIT_CARD) return;

      transaction = transaction.copyWith(type: event.transactionType);

      if (transaction.type == TransactionType.INCOME) {
        transaction = transaction.copyWith(isPaid: null, endDate: null);
      }

      emit(TransactionTypeChangedState(transactionType: transaction.type));
    });

    on<TransactionPaymentMethodChangedEvent>((event, emit) {
      transaction.paymentMethod = event.paymentMethod;
      if(transaction.paymentMethod == PaymentMethod.CREDIT_CARD){
        transaction.type = TransactionType.EXPENSE;
      }
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

    on<TransactionDescriptionChangedEvent>((event, emit) {
      transaction = transaction.copyWith(description: event.description);
      emit(TransactionDescriptionChangedState(description: event.description));
    });

    on<SaveTransactionToDatabaseEvent>((event, emit) async {
      emit(SavingTransactionToDatabaseState());
      final createdTransaction =
          await _createTransactionUseCase.execute(transaction);
      emit(SavedTransactionToDatabaseState(transaction: createdTransaction));
    });

    on<UpdateTransactionToDatabaseEvent>((event, emit) async {
      emit(SavingTransactionToDatabaseState());
      final updated = await _updateTransactionUseCase.execute(transaction);
      emit(SavedTransactionToDatabaseState(transaction: updated));
    });
  }
}
