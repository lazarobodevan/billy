import 'package:billy/enums/limit/limit_type.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/utils/date_utils.dart';

class LimitModel {
  final int? id;
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
    LimitType? limitType,
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
      limitType: limitType ??
          _getLimitType(
            category: category ?? this.category,
            subcategory: subcategory ?? this.subcategory,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            transactionType: transactionType ?? this.transactionType,
          ),
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
      : id = null,
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

  static LimitType _getLimitType(
      {TransactionCategory? category,
      Subcategory? subcategory,
      PaymentMethod? paymentMethod,
      TransactionType? transactionType}) {
    if (category != null) {
      return LimitType.CATEGORY;
    }
    if (subcategory != null) {
      return LimitType.SUBCATEGORY;
    }
    if (paymentMethod != null) {
      return LimitType.PAYMENT_METHOD;
    }
    if (transactionType != null) {
      return LimitType.TRANSACTION_TYPE;
    }
    return LimitType.TRANSACTION_TYPE;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'max_value': maxValue,
      'category_id': category?.id,
      'subcategory_id': subcategory?.id,
      'recurrent': recurrent == true ? 1 : 0,
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
    final category =
        map['category_id'] != null ? TransactionCategory.fromMap(map) : null;
    final subcategory =
        map['subcategory_id'] != null ? Subcategory.fromMap(map) : null;
    final paymentMethod = map['payment_method_id'] != null
        ? PaymentMethodExtension.fromIndex(map['payment_method_id'])
        : null;
    final transactionType = map['transaction_type_id'] != null
        ? TransactionTypeExtension.fromString(map['transaction_type_id'])
        : null;

    return LimitModel(
      id: map['id'],
      maxValue: map['max_value'],
      currentValue: map['current_value'] ?? map['max_value'],
      limitType: LimitModel._getLimitType(
        category: category,
        subcategory: subcategory,
        paymentMethod: paymentMethod,
        transactionType: transactionType,
      ),
      limitTargetName: _getLimitTargetName(map),
      transactionType: transactionType,
      subcategory: subcategory,
      category: category,
      recurrent: map['recurrent'] == 0 ? false : true,
      paymentMethod: paymentMethod,
      beginDate: DateTime.parse(map['begin_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }

  static _getLimitTargetName(Map<String, dynamic> map) {
    if (map['transaction_type_id'] != null) {
      var nameStr =  map['transaction_type_name'];
      var transactionType = TransactionTypeExtension.fromString(nameStr);
      switch(transactionType){
        case TransactionType.INCOME:
          return "Receita";
        case TransactionType.EXPENSE:
          return "Despesa";
        default:
          return "Undefined";
      }
    }

    if (map['subcategory_id'] != null) {
      return map['subcategory_name'];
    }

    if (map['category_id'] != null) {
      return map['category_name'];
    }

    if (map['payment_method_id'] != null) {
      var nameStr = map['payment_method_name'];
      var paymentMethod = PaymentMethodExtension.fromString(nameStr);
      switch (paymentMethod) {
        case PaymentMethod.MONEY:
          return "Dinheiro";
        case PaymentMethod.CREDIT_CARD:
          return "Cartão de Crédito";
        case PaymentMethod.PIX:
          return "Pix";
        default:
          return "Undefined";
      }
    }

    return "Pinto";
  }
}
