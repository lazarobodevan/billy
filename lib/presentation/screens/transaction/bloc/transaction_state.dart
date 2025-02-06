part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class AddTransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class ValueChangedState extends TransactionState{
  final double value;

  const ValueChangedState({required this.value});

  @override
  List<Object?> get props => [value];

}

class TransactionTypeChangedState extends TransactionState{
  final TransactionType transactionType;

  const TransactionTypeChangedState({required this.transactionType});

  @override
  List<Object?> get props => [transactionType];
}

class PaymentMethodChangedState extends TransactionState{
  final PaymentMethod paymentMethod;

  const PaymentMethodChangedState({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class TransactionCategoryChangedState extends TransactionState{

  final TransactionCategory category;

  const TransactionCategoryChangedState({required this.category});

  @override
  List<Object?> get props => [category];

}

class TransactionDescriptionChangedState extends TransactionState{

  final String description;

  const TransactionDescriptionChangedState({required this.description});

  @override
  List<Object?> get props => [description];

}

class TransactionIsPaidChangedState extends TransactionState{

  final bool isPaid;

  const TransactionIsPaidChangedState({required this.isPaid});

  @override
  List<Object?> get props => [isPaid];

}

class SavingTransactionToDatabaseState extends TransactionState{
  @override
  List<Object?> get props => [];
}

class SavedTransactionToDatabaseState extends TransactionState{
  final Transaction transaction;

  const SavedTransactionToDatabaseState({required this.transaction});

  @override
  List<Object?> get props => [transaction];

}


