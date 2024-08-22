part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();
}

class LoadTransactionsDataEvent extends TransactionsEvent{
  @override
  List<Object?> get props => [];

}
