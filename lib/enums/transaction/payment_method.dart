enum PaymentMethod { PIX, MONEY, CREDIT_CARD }

extension PaymentMethodExtension on PaymentMethod {
  static PaymentMethod fromString(String paymentMethodStr) {
    return PaymentMethod.values.firstWhere(
      (e) => e.toString().split('.').last == paymentMethodStr,
      orElse: () =>
          throw ArgumentError('Invalid payment method: $paymentMethodStr'),
    );
  }

  static int toDatabase(PaymentMethod paymentMethod) {
    if (paymentMethod == PaymentMethod.PIX) return 1;
    if (paymentMethod == PaymentMethod.CREDIT_CARD) return 2;
    return 3;
  }

  static PaymentMethod fromIndex(int index) {
    switch (index) {
      case 1:
        return PaymentMethod.PIX;
      case 2:
        return PaymentMethod.MONEY;
      case 3:
        return PaymentMethod.CREDIT_CARD;
      default:
        throw ArgumentError('Invalid index for PaymentMethod: $index');
    }
  }
}
