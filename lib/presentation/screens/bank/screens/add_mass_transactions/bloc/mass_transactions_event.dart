part of 'mass_transactions_bloc.dart';

abstract class MassTransactionsEvent extends Equatable {
  const MassTransactionsEvent();
}

class LoadMassTransactionsEvent extends MassTransactionsEvent{

  final BankType bankType;
  final bool isInvoice;

  const LoadMassTransactionsEvent({required this.bankType, required this.isInvoice});

  @override
  List<Object?> get props => [bankType, isInvoice];

}
