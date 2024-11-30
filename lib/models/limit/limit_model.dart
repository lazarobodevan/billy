import 'package:billy/enums/limit/limit_type.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/utils/date_utils.dart';

class LimitModel {
  final int id;
  final double maxValue;
  final double currentValue;
  final String limitTargetName;
  final LimitType? limitType;
  final bool? recurrent;
  final TransactionCategory? category;
  final Subcategory? subcategory;
  final PaymentMethod? paymentMethod;
  final TransactionType? transactionType;
  final DateTime beginDate;
  final DateTime endDate;

  LimitModel({
    required this.id,
    required this.maxValue,
    required this.currentValue,
    required this.limitTargetName,
    required this.beginDate,
    required this.endDate,
    this.recurrent = false,
    this.limitType,
    this.category,
    this.subcategory,
    this.paymentMethod,
    this.transactionType,
  });

  LimitModel copyWith({
    int? id,
    double? maxValue,
    double? currentValue,
    String? limitTargetName,
    bool? recurrent,
    TransactionCategory? category,
    Subcategory? subcategory,
    PaymentMethod? paymentMethod,
    TransactionType? transactionType,
    DateTime? beginDate,
    DateTime? endDate,
  }) {
    return LimitModel(
      id: id ?? this.id,
      maxValue: maxValue ?? this.maxValue,
      currentValue: currentValue ?? this.currentValue,
      limitTargetName: limitTargetName ?? this.limitTargetName,
      recurrent: recurrent ?? this.recurrent,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionType: transactionType ?? this.transactionType,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
    );
  }

  LimitModel.empty()
      : id = 0,
        maxValue = 0.0,
        currentValue = 0.0,
        limitTargetName = '',
        limitType = null,
        recurrent = false,
        category = null,
        subcategory = null,
        paymentMethod = null,
        transactionType = null,
        beginDate = MyDateUtils.getFirstDayOfMonth(),
        endDate = MyDateUtils.getLastDayOfMonth();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'max_value': maxValue,
      'category_id': category?.id,
      'subcategory_id': subcategory?.id,
      'payment_method_id': paymentMethod != null
          ? PaymentMethodExtension.toDatabase(paymentMethod!)
          : null,
      'transaction_type_id': transactionType != null
          ? TransactionTypeExtension.toDatabase(transactionType!)
          : null,
      'begin_date': beginDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }

  static LimitModel fromMap(Map<String, dynamic> map) {
    return LimitModel(
        id: map['id'],
        maxValue: map['max_value'],
        currentValue: map['current_value'],
        limitTargetName: _getLimitTargetName(map),
        transactionType: map['transaction_type_id'] != null
            ? TransactionTypeExtension.fromString(map['transaction_type_id'])
            : null,
        subcategory: map['subcategory_id'] != null
            ? Subcategory.fromMap(
                map['subcategory_id'],
              )
            : null,
        category: map['category_id'] != null
            ? TransactionCategory.fromMap(map)
            : null,
        recurrent: map['recurrent'] == 0 ? false : true,
        paymentMethod: map['payment_method_id'] != null
            ? PaymentMethodExtension.fromIndex(map['payment_method_id'])
            : null,
        beginDate: DateTime.parse(map['begin_date']),
        endDate: DateTime.parse(map['end_date']));
  }

  static _getLimitTargetName(Map<String, dynamic> map) {
    if (map['transaction_type_id'] != null) {
      return map['transaction_type_name'];
    }

    if (map['subcategory_id'] != null) {
      return map['subcategory_name'];
    }

    if (map['category_id'] != null) {
      return map['category_name'];
    }

    if (map['payment_method_id'] != null) {
      return map['payment_method_name'];
    }

    return "Pinto";
  }
}
