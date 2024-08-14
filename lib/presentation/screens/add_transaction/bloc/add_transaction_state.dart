part of 'add_transaction_bloc.dart';

abstract class AddTransactionState extends Equatable {
  const AddTransactionState();
}

class AddTransactionInitial extends AddTransactionState {
  @override
  List<Object> get props => [];
}

class ValueChangedState extends AddTransactionState{
  final double value;

  const ValueChangedState({required this.value});

  @override
  List<Object?> get props => [value];

}

class TransactionTypeChangedState extends AddTransactionState{
  final TransactionType transactionType;

  const TransactionTypeChangedState({required this.transactionType});

  @override
  List<Object?> get props => [transactionType];
}

class PaymentMethodChangedState extends AddTransactionState{
  final PaymentMethod paymentMethod;

  const PaymentMethodChangedState({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class TransactionCategoryChangedState extends AddTransactionState{

  final TransactionCategory category;

  const TransactionCategoryChangedState({required this.category});

  @override
  List<Object?> get props => [category];

}

class TransactionNameChangedState extends AddTransactionState{

  final String name;

  const TransactionNameChangedState({required this.name});

  @override
  List<Object?> get props => [name];

}

class SavingTransactionToDatabaseState extends AddTransactionState{
  @override
  List<Object?> get props => [];
}

class SavedTransactionToDatabaseState extends AddTransactionState{
  final Transaction transaction;

  const SavedTransactionToDatabaseState({required this.transaction});

  @override
  List<Object?> get props => [transaction];

}
