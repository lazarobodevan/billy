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
