enum TransactionType{
  INCOME,
  EXPENSE
}

extension TransactionTypeExtension on TransactionType{
  static TransactionType fromString(String transactionTypeStr){
    return TransactionType.values.firstWhere((e)=>e.toString().split('.').last == transactionTypeStr,
      orElse: ()=> throw ArgumentError('Invalid transaction type: $transactionTypeStr'),
    );
  }
}