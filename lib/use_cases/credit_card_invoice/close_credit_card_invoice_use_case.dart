import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/create_credit_card_invoice_use_case.dart';

class CloseCreditCardInvoiceUseCase {
  final ICreditCardInvoicesRepository creditCardInvoicesRepository;
  final IBalanceRepository balanceRepository;

  const CloseCreditCardInvoiceUseCase(
      {required this.creditCardInvoicesRepository,
      required this.balanceRepository});

  Future<void> execute() async {
    var mostRecent = await creditCardInvoicesRepository.getMostRecent();
    var createCreditCardInvoiceUseCase = CreateCreditCardInvoiceUseCase(
        creditCardInvoicesRepository: creditCardInvoicesRepository);

    if (mostRecent.endDate.isBefore(DateTime.now())) {
      await balanceRepository.setCreditLimitUsed(0);
      await createCreditCardInvoiceUseCase.execute(CreditCardInvoiceModel(
          id: 0,
          total: 0,
          beginDate: mostRecent.endDate.add(const Duration(days: 1)),
          endDate: mostRecent.endDate.add(const Duration(days: 30)),

      ));
    }
  }
}
