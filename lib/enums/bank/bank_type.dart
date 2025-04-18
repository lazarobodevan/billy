enum BankType{
  SICOOB
}

extension BankTypeExtension on BankType{
  static BankType fromString(String transactionTypeStr) {
    return BankType.values.firstWhere(
          (e) => e.toString().split('.').last == transactionTypeStr,
      orElse: () =>
      throw ArgumentError('Invalid transaction type: $transactionTypeStr'),
    );
  }
}