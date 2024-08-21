import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/repositories/balance/i_balance_repository.dart';

import '../database_helper.dart';

class BalanceRepository implements IBalanceRepository{

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Balance> getBalance() async {
    final db = await _databaseHelper.database;
    var balanceMap = await db.query('balance');

    return Balance.fromMap(balanceMap.first);
  }

  @override
  Future<double> setBalance(double balance) async {
    final db = await _databaseHelper.database;
    await db.update('balance', {'balance':balance});

    return balance;
  }

  @override
  Future<double> setCreditLimit(double limit) async {
    final db = await _databaseHelper.database;
    await db.update('balance', {'credit_limit':limit});

    return limit;
  }

  @override
  Future<double> setCreditLimitUsed(double limitUsed) async {
    final db = await _databaseHelper.database;
    await db.update('balance', {'credit_limit_used':limitUsed});

    return limitUsed;
  }

}