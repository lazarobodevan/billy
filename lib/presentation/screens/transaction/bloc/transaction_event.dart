part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class ResetTransaction extends TransactionEvent{

  @override
  List<Object?> get props => [];

}

class EraseValue extends TransactionEvent{
  @override
  List<Object?> get props => [];

}

class TransactionTypeChangedEvent extends TransactionEvent{
  final TransactionType transactionType;

  const TransactionTypeChangedEvent({required this.transactionType});

  @override
  List<Object?> get props => [transactionType];
}

class TransactionPaymentMethodChangedEvent extends TransactionEvent{
  final PaymentMethod paymentMethod;

  const TransactionPaymentMethodChangedEvent({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];

}

class TransactionCategoryChangedEvent extends TransactionEvent{
  final TransactionCategory category;

  const TransactionCategoryChangedEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class TransactionValueDigitChangedEvent extends TransactionEvent{
  final int value;

  const TransactionValueDigitChangedEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class TransactionValueChangedEvent extends TransactionEvent{
  final String value;

  const TransactionValueChangedEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class TransactionNameChangedEvent extends TransactionEvent{
  final String name;

  const TransactionNameChangedEvent({required this.name});

  @override
  List<Object?> get props => [];
}

class TransactionDateChangedEvent extends TransactionEvent{
  final DateTime date;

  const TransactionDateChangedEvent({required this.date});

  @override
  List<Object?> get props => [];
}

class TransactionEndDateChangedEvent extends TransactionEvent{
  final DateTime? date;

  const TransactionEndDateChangedEvent({required this.date});

  @override
  List<Object?> get props => [];
}

class TransactionIsPaidChangedEvent extends TransactionEvent{
  final bool isPaid;

  const TransactionIsPaidChangedEvent({required this.isPaid});

  @override
  List<Object?> get props => [];
}

class SaveTransactionToDatabaseEvent extends TransactionEvent{

  @override
  List<Object?> get props => [];

}

class SetTransactionEvent extends TransactionEvent{

  final Transaction transaction;

  const SetTransactionEvent({required this.transaction});

  @override
  List<Object?> get props => [transaction];

}


class UpdateTransactionToDatabaseEvent extends TransactionEvent{
  @override
  List<Object?> get props => [];

}
