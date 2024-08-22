import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';

class Transaction {
  final int? id;
  String name;
  double value;
  TransactionCategory? category;
  TransactionType type;
  PaymentMethod paymentMethod;
  DateTime date;
  DateTime? endDate;
  bool? isPaid;

  Transaction(
      {this.id,
      required this.name,
      required this.value,
      required this.category,
      required this.type,
      required this.paymentMethod,
      required this.date,
      this.endDate,
      this.isPaid});

  Transaction.empty({
    this.id,
    this.name = "",
    this.value = 0,
    TransactionCategory? category,
    this.type = TransactionType.EXPENSE,
    this.paymentMethod = PaymentMethod.PIX,
    DateTime? date,
    this.endDate,
    this.isPaid,
  })  : category = TransactionCategory.empty(),
        date = date ?? DateTime.now();

  _getIsPaidToDatabase() {
    if (isPaid == null) return isPaid;

    if (isPaid == true) {
      return 1;
    } else {
      return 0;
    }
  }

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
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      category: category ?? this.category,
      type: type ?? this.type,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      isPaid: isPaid ?? this.isPaid,
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
      'end_date': endDate?.toIso8601String(),
      'paid': _getIsPaidToDatabase()
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      isPaid: map['paid'] != null
          ? map['paid'] == 1
              ? true
              : false
          : null,
      name: map['name'],
      value: map['value'],
      category: map['category_id'] != null ? TransactionCategory.fromMap(map) : null,
      type: TransactionTypeExtension.fromString(map['type']),
      paymentMethod: PaymentMethodExtension.fromString(map['payment_method']),
      date: DateTime.parse(map['date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
    );
  }
}
