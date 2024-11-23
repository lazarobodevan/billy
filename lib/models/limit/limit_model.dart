import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';

class LimitModel {
  final int id;
  final double maxValue;
  final String limitTargetName;
  final TransactionCategory? category;
  final Subcategory? subcategory;
  final PaymentMethod? paymentMethod;
  final TransactionType? transactionType;

  LimitModel(
      {required this.id,
      required this.maxValue,
      required this.limitTargetName,
      this.category,
      this.subcategory,
      this.paymentMethod,
      this.transactionType});
}
