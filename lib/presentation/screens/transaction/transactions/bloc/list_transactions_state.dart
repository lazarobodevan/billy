part of 'list_transactions_bloc.dart';

abstract class ListTransactionsState extends Equatable {
  const ListTransactionsState();
}

class ListTransactionsInitial extends ListTransactionsState {
  @override
  List<Object> get props => [];
}

class LoadingTransactionsDataState extends ListTransactionsState {
  final bool isFirstFetch;

  const LoadingTransactionsDataState({this.isFirstFetch = false});
  @override
  List<Object> get props => [];
}

class LoadedTransactionsDataState extends ListTransactionsState {
  final List<String> periods;
  final Map<DateTime, List<Transaction>> transactions;

  const LoadedTransactionsDataState({required this.periods, required this.transactions});

  @override
  List<Object> get props => [periods, transactions];
}

class ErrorLoadingTransactionsDataState extends ListTransactionsState {
  @override
  List<Object> get props => [];
}

class DeletingTransactionState extends ListTransactionsState{
  @override

  List<Object?> get props => [];

}

class DeletedTransactionState extends ListTransactionsState{
  @override

  List<Object?> get props => [];

}