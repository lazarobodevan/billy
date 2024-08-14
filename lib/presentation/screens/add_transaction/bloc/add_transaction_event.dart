part of 'add_transaction_bloc.dart';

abstract class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();
}

class ResetValue extends AddTransactionEvent{
  @override
  List<Object?> get props => [];

}

class TriggerValue extends AddTransactionEvent{

  final int value;

  const TriggerValue({required this.value});

  @override
  List<Object?> get props => [value];

}

class EraseValue extends AddTransactionEvent{
  @override
  List<Object?> get props => [];

}

class ChangeTransactionType extends AddTransactionEvent{
  final TransactionType transactionType;

  const ChangeTransactionType({required this.transactionType});

  @override
  List<Object?> get props => [transactionType];
}

class ChangePaymentMethod extends AddTransactionEvent{
  final PaymentMethod paymentMethod;

  const ChangePaymentMethod({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];

}

class ChangeCategoryEvent extends AddTransactionEvent{
  final TransactionCategory category;

  const ChangeCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class ChangeTransactionNameEvent extends AddTransactionEvent{
  final String name;

  const ChangeTransactionNameEvent({required this.name});

  @override
  List<Object?> get props => [];
}

class ChangeTransactionDateEvent extends AddTransactionEvent{
  final DateTime date;

  const ChangeTransactionDateEvent({required this.date});

  @override
  List<Object?> get props => [];
}

class ChangeTransactionEndDateEvent extends AddTransactionEvent{
  final DateTime? date;

  const ChangeTransactionEndDateEvent({required this.date});

  @override
  List<Object?> get props => [];
}

class ChangeTransactionIsPaidEvent extends AddTransactionEvent{
  final bool isPaid;

  const ChangeTransactionIsPaidEvent({required this.isPaid});

  @override
  List<Object?> get props => [];
}

class SaveTransactionToDatabaseEvent extends AddTransactionEvent{

  @override
  List<Object?> get props => [];

}