part of 'list_transactions_bloc.dart';

abstract class ListTransactionsEvent extends Equatable {
  const ListTransactionsEvent();
}

class LoadTransactionsEvent extends ListTransactionsEvent{
  final bool? isFirstFetch;

  const LoadTransactionsEvent({this.isFirstFetch = false});

  @override
  List<Object?> get props => [];

}

class DeleteTransactionEvent extends ListTransactionsEvent{
  final int id;

  const DeleteTransactionEvent({required this.id});

  @override
  List<Object?> get props => [id];

}
