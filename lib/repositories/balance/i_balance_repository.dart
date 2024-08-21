import 'package:billy/models/balance/balance_model.dart';

abstract class IBalanceRepository{
  Future<Balance> getBalance();
  Future<double> setCreditLimit(double limit);
  Future<double> setCreditLimitUsed(double limitUsed);
  Future<double> setBalance(double balance);
}