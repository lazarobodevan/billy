part of 'credit_card_invoice_bloc.dart';

abstract class CreditCardInvoiceEvent extends Equatable {
  const CreditCardInvoiceEvent();
}

class InvoiceInitialCheckEvent extends CreditCardInvoiceEvent{
  @override
  List<Object?> get props => [];

}

class LoadInvoicesEvent extends CreditCardInvoiceEvent{

  @override
  List<Object?> get props => [];

}

class UpdateInvoiceEvent extends CreditCardInvoiceEvent{
  final CreditCardInvoiceModel invoice;

  const UpdateInvoiceEvent({required this.invoice});

  @override
  List<Object?> get props => [invoice];

}