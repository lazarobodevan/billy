part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {
  @override
  List<Object> get props => [];
}

class LoadingTransactionsDataState extends TransactionsState {
  @override
  List<Object> get props => [];
}

class LoadedTransactionsDataState extends TransactionsState {
  final List<String> periods;
  final List<Transaction> transactions;

  const LoadedTransactionsDataState({required this.periods, required this.transactions});

  @override
  List<Object> get props => [periods, transactions];
}

class ErrorLoadingTransactionsDataState extends TransactionsState {
  @override
  List<Object> get props => [];
}
