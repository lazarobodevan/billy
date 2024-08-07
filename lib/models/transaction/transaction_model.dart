import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';

class Transaction {
  final int? id;
  String name;
  double value;
  String category;
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
    this.category = "",
    this.type = TransactionType.EXPENSE,
    this.paymentMethod = PaymentMethod.PIX,
    DateTime? date,
    this.endDate,
    this.isPaid,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'category': category,
      'date': date,
      'endDate': endDate,
      'isPaid': isPaid
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      isPaid: map['is_paid'],
      name: map['name'],
      value: map['value'],
      category: map['category'],
      type: TransactionTypeExtension.fromString(map['type']),
      paymentMethod: PaymentMethodExtension.fromString(map['payment_method']),
      date: DateTime.parse(map['date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
    );
  }
}
