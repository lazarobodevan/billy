part of 'mass_transactions_bloc.dart';

abstract class MassTransactionsState extends Equatable {
  const MassTransactionsState();
}

class MassTransactionsInitial extends MassTransactionsState {
  @override
  List<Object> get props => [];
}

class LoadingMassTransactionsState extends MassTransactionsState{
  @override
  List<Object?> get props => [];
}

class LoadedMassTransactionsState extends MassTransactionsState{

  final List<Transaction> transactions;

  const LoadedMassTransactionsState({required this.transactions});

  @override
  List<Object?> get props => [transactions];

}

class LoadMassTransactionsErrorState extends MassTransactionsState{

  final String message;

  const LoadMassTransactionsErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}