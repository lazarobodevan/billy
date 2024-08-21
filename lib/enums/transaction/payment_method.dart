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

  static int toDatabase(PaymentMethod paymentMethod){
    if(paymentMethod == PaymentMethod.PIX) return 1;
    if(paymentMethod == PaymentMethod.CREDIT_CARD) return 2;
    return 3;
  }
}
