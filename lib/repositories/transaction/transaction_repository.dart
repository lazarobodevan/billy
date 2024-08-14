import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class TransactionRepository implements ITransactionRepository{
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Transaction> create(Transaction transaction) async {
    final db = await _databaseHelper.database;
    final transactionMap = transaction.toMap();
    final id = await db.insert('transactions', transactionMap);
    final createdTransaction = await db.query('transactions', where: 'id = ?', whereArgs: [id], limit: 1);

    return Transaction.fromMap(createdTransaction[0]);

  }

  @override
  Future<Transaction> delete(int id) async{
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getAll({
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await _databaseHelper.database;

    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM transactions');
    final totalCount = countResult.isNotEmpty ? countResult.first['count'] as int : 0;

    if (offset >= totalCount) {
      return [];
    }

    final transactions = await db.rawQuery('''
    SELECT 
      transactions.id,
      transactions.name,
      transactions.value,
      transactions.category_id,
      transactions.type,
      transactions.payment_method,
      transactions.date,
      transactions.end_date,
      transactions.is_paid,
      categories.name AS category_name,
      categories.icon AS category_icon,
      categories.color AS category_color
    FROM transactions
    LEFT JOIN categories ON transactions.category_id = categories.id
    LIMIT ? OFFSET ?
  ''', [limit, offset]);

    return transactions.map((map) {
      final category = TransactionCategory.fromMap(map);
      return Transaction.fromMap(map)..category = category;
    }).toList();
  }

  @override
  Future<Transaction> update(Transaction transaction) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}