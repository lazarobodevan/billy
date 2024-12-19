import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';
import 'package:billy/use_cases/credit_card_invoice/get_or_create_credit_card_invoice_to_transaction.dart';
import 'package:billy/use_cases/transaction/update_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock
    implements ITransactionRepository {}

class MockBalanceRepository extends Mock implements IBalanceRepository {}

class MockInvoicesRepository extends Mock
    implements ICreditCardInvoicesRepository {}

class MockGetOrCreateCreditCardInvoiceToTransaction extends Mock
    implements GetOrCreateCreditCardInvoiceToTransaction {}

void main() {
  late MockTransactionRepository transactionRepository;
  late MockBalanceRepository balanceRepository;
  late MockInvoicesRepository invoicesRepository;
  late UpdateTransactionUseCase updateTransactionUseCase;
  late MockGetOrCreateCreditCardInvoiceToTransaction getOrCreateInvoiceUseCase;

  setUpAll(() {
    transactionRepository = MockTransactionRepository();
    balanceRepository = MockBalanceRepository();
    invoicesRepository = MockInvoicesRepository();
    getOrCreateInvoiceUseCase = MockGetOrCreateCreditCardInvoiceToTransaction();
    updateTransactionUseCase = UpdateTransactionUseCase(
      transactionRepository: transactionRepository,
      balanceRepository: balanceRepository,
      invoicesRepository: invoicesRepository,
    );
    registerFallbackValue(Transaction.empty());
    registerFallbackValue(CreditCardInvoiceModel.empty());
  });

  test(
      'Should update transaction when payment method changes from other to CREDIT_CARD',
      () async {
    // Arrange

    final invoice = CreditCardInvoiceModel(
      id: 1,
      beginDate: MyDateUtils.getFirstDayOfMonth(),
      endDate: MyDateUtils.getLastDayOfMonth(),
      total: 0,
    );

    final accountBalance = Balance(
      balance: 500.0,
      limitUsed: 200.0,
      creditLimit: 400,
    );

    final oldTransaction = Transaction(
      id: 1,
      value: 100.0,
      paymentMethod: PaymentMethod.MONEY,
      category: TransactionCategory.empty(),
      date: DateTime.now(),
      name: "Test",
      type: TransactionType.EXPENSE,
    );

    final updatedTransaction = oldTransaction.copyWith(
        paymentMethod: PaymentMethod.CREDIT_CARD, invoice: invoice);

    when(()=>transactionRepository.getById(1))
        .thenAnswer((_) async => oldTransaction);
    when(()=> invoicesRepository.getMostRecent()).thenAnswer((_) async => invoice);
    when(()=>balanceRepository.getBalance())
        .thenAnswer((_) async => accountBalance);
    when(()=> balanceRepository.setCreditLimitUsed(300)).thenAnswer((_) async=> 300);
    when(()=> balanceRepository.setBalance(600)).thenAnswer((_)async =>600);
    when(()=>transactionRepository.update(any()))
        .thenAnswer((_) async => updatedTransaction);

    when(()=>invoicesRepository.updateTotal(any(), any())).thenAnswer((_) async {});
    when(()=> getOrCreateInvoiceUseCase
        .execute(updatedTransaction))
        .thenAnswer((_) async => invoice);

    // Act
    final result = await updateTransactionUseCase.execute(updatedTransaction);

    // Assert
    expect(result, updatedTransaction);
    verify(()=>balanceRepository.setBalance(600.0)).called(1);
    verify(()=>balanceRepository.setCreditLimitUsed(300.0)).called(1);
    verify(()=>invoicesRepository.updateTotal(invoice.id!, 300.0)).called(1);
    verify(()=>transactionRepository.update(any())).called(1);
  });

  test(
      'Should update transaction when payment method changes from CREDIT_CARD to other',
          () async {
        // Arrange

        final invoice = CreditCardInvoiceModel(
          id: 1,
          beginDate: MyDateUtils.getFirstDayOfMonth(),
          endDate: MyDateUtils.getLastDayOfMonth(),
          total: 100,
        );

        final accountBalance = Balance(
          balance: 600.0,
          limitUsed: invoice.total,
          creditLimit: 400,
        );

        final oldTransaction = Transaction(
          id: 1,
          value: invoice.total,
          paymentMethod: PaymentMethod.CREDIT_CARD,
          category: TransactionCategory.empty(),
          date: DateTime.now(),
          name: "Test",
          type: TransactionType.EXPENSE,
          invoice: invoice
        );

        final updatedTransaction = oldTransaction.copyWith(
            paymentMethod: PaymentMethod.MONEY, invoice: CreditCardInvoiceModel.empty());

        when(()=>transactionRepository.getById(oldTransaction.id!))
            .thenAnswer((_) async => oldTransaction);
        when(()=> invoicesRepository.getMostRecent()).thenAnswer((_) async => invoice);
        when(()=>balanceRepository.getBalance())
            .thenAnswer((_) async => accountBalance);
        when(()=> balanceRepository.setCreditLimitUsed(0)).thenAnswer((_) async=> 0);
        when(()=> balanceRepository.setBalance(500)).thenAnswer((_)async =>500);
        when(()=>transactionRepository.update(any()))
            .thenAnswer((_) async => updatedTransaction);

        when(()=>invoicesRepository.updateTotal(any(), any())).thenAnswer((_) async {});
        when(()=> getOrCreateInvoiceUseCase
            .execute(updatedTransaction))
            .thenAnswer((_) async => invoice);

        // Act
        final result = await updateTransactionUseCase.execute(updatedTransaction);

        // Assert
        expect(result, updatedTransaction);
        verify(()=>balanceRepository.setBalance(500.0)).called(1);
        verify(()=>balanceRepository.setCreditLimitUsed(0.0)).called(1);
        verify(()=>invoicesRepository.updateTotal(invoice.id!, 0)).called(1);
        verify(()=>transactionRepository.update(any())).called(1);
      });
}
