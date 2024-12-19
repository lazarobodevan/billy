part of 'credit_card_invoice_bloc.dart';

abstract class CreditCardInvoiceState extends Equatable {
  const CreditCardInvoiceState();
}

class CreditCardInvoiceInitial extends CreditCardInvoiceState {
  @override
  List<Object> get props => [];
}

class LoadingInvoicesState extends CreditCardInvoiceState{
  @override
  List<Object?> get props => [];

}
class LoadedInvoicesState extends CreditCardInvoiceState{
  final List<CreditCardInvoiceModel> invoices;

  const LoadedInvoicesState({required this.invoices});

  @override
  List<Object?> get props => [invoices];

}

class LoadInvoicesErrorState extends CreditCardInvoiceState{
  final String message;

  const LoadInvoicesErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}