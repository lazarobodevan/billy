class Balance{
  final double creditLimit;
  final double limitUsed;
  final double balance;

  Balance({this.creditLimit = 0, this.limitUsed = 0, this.balance = 0});

  static Balance fromMap(Map<String, dynamic> map){
    return Balance(
      balance: map['balance'] as double,
      creditLimit: (map['credit_limit'] as double),
      limitUsed: map['credit_limit_used'] as double
    );
  }
}