import 'package:billy/repository/database_helper.dart';
import 'package:billy/transaction/models/transaction_model.dart';
import 'package:billy/transaction/repository/i_transaction_repository.dart';

class TransactionRepository implements ITransactionRepository{
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Transaction> create(Transaction transaction) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('transactions', transaction.toMap());
    final createdTransaction = await db.query('transactions', where: 'id = ?', whereArgs: [id], limit: 1);

    return Transaction.fromMap(createdTransaction[0]);

  }

  @override
  Future<Transaction> delete(int id) async{
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getAll() async{
    final db = await _databaseHelper.database;
    final transactions = await db.query('transactions');
    return transactions.map((map)=> Transaction.fromMap(map)).toList();
  }

  @override
  Future<Transaction> update(Transaction transaction) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}