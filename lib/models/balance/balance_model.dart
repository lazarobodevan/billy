import 'package:billy/utils/date_utils.dart';

class Balance {
  final double creditLimit;
  final double limitUsed;
  final double balance;
  final int invoicePayDay;

  Balance(
      {this.creditLimit = 0,
      this.limitUsed = 0,
      this.balance = 0,
      this.invoicePayDay = 1});

  static Balance fromMap(Map<String, dynamic> map) {
    return Balance(
        balance: map['balance'] as double,
        creditLimit: (map['credit_limit'] as double),
        limitUsed: map['credit_limit_used'] as double,
        invoicePayDay: map['invoice_pay_day']);
  }
}
