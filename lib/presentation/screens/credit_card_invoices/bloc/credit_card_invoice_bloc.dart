import 'dart:async';

import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/close_credit_card_invoice_use_case.dart';
import 'package:billy/use_cases/credit_card_invoice/get_credit_card_invoices_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'credit_card_invoice_event.dart';

part 'credit_card_invoice_state.dart';

class CreditCardInvoiceBloc
    extends Bloc<CreditCardInvoiceEvent, CreditCardInvoiceState> {
  final ICreditCardInvoicesRepository creditCardInvoicesRepository;
  final IBalanceRepository balanceRepository;
  late final GetCreditCardInvoicesUseCase getCreditCardInvoicesUseCase;

  CreditCardInvoiceBloc(
      {required this.creditCardInvoicesRepository,
      required this.balanceRepository})
      : super(CreditCardInvoiceInitial()) {

    getCreditCardInvoicesUseCase = GetCreditCardInvoicesUseCase(
        creditCardInvoicesRepository: creditCardInvoicesRepository);


    on<InvoiceInitialCheckEvent>((event, emit) async {
      try {
        await CloseCreditCardInvoiceUseCase(
                balanceRepository: balanceRepository,
                creditCardInvoicesRepository: creditCardInvoicesRepository)
            .execute();

      } catch (e) {
        print(e);
      }
    });

    on<LoadInvoicesEvent>((event, emit) async {
      try {
        emit(LoadingInvoicesState());
        var invoices = await getCreditCardInvoicesUseCase.execute();
        emit(LoadedInvoicesState(invoices: invoices));
      } catch (e) {
        emit(LoadInvoicesErrorState(message: e.toString()));
      }
    });
  }
}
