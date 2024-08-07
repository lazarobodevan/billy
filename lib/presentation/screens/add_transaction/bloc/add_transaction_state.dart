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
