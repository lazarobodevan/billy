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