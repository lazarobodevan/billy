import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';

class Transaction {
  final int? id;
  String name;
  double value;
  TransactionCategory? category;
  TransactionType type;
  PaymentMethod paymentMethod;
  DateTime date;
  CreditCardInvoiceModel? invoice;

  Transaction(
      {this.id,
      required this.name,
      required this.value,
      required this.category,
      required this.type,
      required this.paymentMethod,
      required this.date,
        this.invoice
      });

  Transaction.empty({
    this.id,
    this.name = "",
    this.value = 0,
    TransactionCategory? category,
    this.type = TransactionType.EXPENSE,
    this.paymentMethod = PaymentMethod.PIX,
    DateTime? date,
    CreditCardInvoiceModel? invoice
  })  : category = TransactionCategory.empty(),
        date = date ?? DateTime.now(),
        invoice = CreditCardInvoiceModel.empty();


  Transaction copyWith({
    int? id,
    String? name,
    double? value,
    TransactionCategory? category,
    TransactionType? type,
    PaymentMethod? paymentMethod,
    DateTime? date,
    DateTime? endDate,
    bool? isPaid,
    CreditCardInvoiceModel? invoice
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      category: category ?? this.category,
      type: type ?? this.type,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      invoice: invoice ?? this.invoice
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'category_id': category?.id,
      'subcategory_id':
          category?.subcategories != null && category!.subcategories!.isNotEmpty
              ? category!.subcategories![0].id
              : null,
      'type_id': TransactionTypeExtension.toDatabase(type),
      'payment_method_id': PaymentMethodExtension.toDatabase(paymentMethod),
      'date': date.toIso8601String(),
      'invoice_id': invoice?.id,
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      value: map['value'],
      category: map['category_id'] != null ? TransactionCategory.fromMap(map) : null,
      type: TransactionTypeExtension.fromString(map['type']),
      paymentMethod: PaymentMethodExtension.fromString(map['payment_method']),
      invoice: CreditCardInvoiceModel.fromMap(map),
      date: DateTime.parse(map['date']),
    );
  }
}
