enum TransactionType { INCOME, EXPENSE, TRANSFER }

extension TransactionTypeExtension on TransactionType {
  static TransactionType fromString(String transactionTypeStr) {
    return TransactionType.values.firstWhere(
      (e) => e.toString().split('.').last == transactionTypeStr,
      orElse: () =>
          throw ArgumentError('Invalid transaction type: $transactionTypeStr'),
    );
  }

  static int toDatabase(TransactionType type) {
    if (type == TransactionType.INCOME) return 1;
    if (type == TransactionType.EXPENSE) return 2;
    return 3;
  }

  static TransactionType fromIndex(int index) {
    switch (index) {
      case 1:
        return TransactionType.INCOME;
      case 2:
        return TransactionType.EXPENSE;
      case 3:
        return TransactionType.TRANSFER;
      default:
        throw ArgumentError('Invalid index for TransactionType: $index');
    }
  }
}
