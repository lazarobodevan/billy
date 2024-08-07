enum PaymentMethod{
  PIX,
  MONEY,
  CREDIT_CARD
}

extension PaymentMethodExtension on PaymentMethod{
  static PaymentMethod fromString(String paymentMethodStr){
    return PaymentMethod.values.firstWhere((e)=>e.toString().split('.').last == paymentMethodStr,
      orElse: ()=> throw ArgumentError('Invalid payment method: $paymentMethodStr'),
    );
  }
}