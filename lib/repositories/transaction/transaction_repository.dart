import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class TransactionRepository implements ITransactionRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Transaction> create(Transaction transaction) async {
    final db = await _databaseHelper.database;
    final transactionMap = transaction.toMap();
    final id = await db.insert('transactions', transactionMap);
    //final createdTransaction = await db.query('transactions', where: 'id = ?', whereArgs: [id], limit: 1);

    return transaction.copyWith(id: id);
  }

  @override
  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;

    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Transaction>> getAll({
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await _databaseHelper.database;


    final transactions = await db.rawQuery('''
    SELECT 
      transactions.id,
      transactions.description,
      transactions.value,
      transactions.category_id,
      transactions.subcategory_id,
      transactions.type_id,
      transactions.payment_method_id,
      transactions.date,
      transactions.invoice_id,    
      categories.name AS category_name,
      categories.icon AS category_icon,
      categories.color AS category_color,
      subcategories.name AS subcategory_name,
      subcategories.icon AS subcategory_icon,
      subcategories.color AS subcategory_color,
      transaction_types.name AS type,
      payment_methods.name AS payment_method
    FROM transactions
    LEFT JOIN categories ON transactions.category_id = categories.id
    LEFT JOIN subcategories ON transactions.subcategory_id = subcategories.id
    LEFT JOIN transaction_types ON transactions.type_id = transaction_types.id
    LEFT JOIN payment_methods ON transactions.payment_method_id = payment_methods.id
    ORDER BY transactions.date DESC
    LIMIT ? OFFSET ?
  ''', [limit, offset]);

    return transactions.map((map) {
      return Transaction.fromMap(map);
    }).toList();
  }

  @override
  Future<Map<DateTime, List<Transaction>>> getAllGroupedByDate({
    int limit = 10,
    int pageNumber = 0,
  }) async {
    final db = await _databaseHelper.database;
    int offset = pageNumber * limit;

    final transactions = await db.rawQuery('''
        SELECT 
          transactions.id,
          transactions.description,
          transactions.value,
          transactions.category_id,
          transactions.subcategory_id,
          transactions.type_id,
          transactions.payment_method_id,
          transactions.date,
          transactions.invoice_id as invoice_id,
          categories.name AS category_name,
          categories.icon AS category_icon,
          categories.color AS category_color,
          subcategories.name AS subcategory_name,
          subcategories.icon AS subcategory_icon,
          subcategories.color AS subcategory_color,
          transaction_types.name AS type,
          payment_methods.name AS payment_method
        FROM transactions
        LEFT JOIN categories ON transactions.category_id = categories.id
        LEFT JOIN subcategories ON transactions.subcategory_id = subcategories.id
        LEFT JOIN transaction_types ON transactions.type_id = transaction_types.id
        LEFT JOIN payment_methods ON transactions.payment_method_id = payment_methods.id
        ORDER BY transactions.date DESC
        LIMIT ? OFFSET ?
      ''', [limit, offset]);

    final groupedTransactions = <DateTime, List<Transaction>>{};

    for (var map in transactions) {
      final transaction = Transaction.fromMap(map);
      final date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);

      if (groupedTransactions.containsKey(date)) {
        groupedTransactions[date]!.add(transaction);
      } else {
        groupedTransactions[date] = [transaction];
      }
    }

    return groupedTransactions;
  }

  @override
  Future<Transaction> update(Transaction transaction) async {
    final db = await _databaseHelper.database;

    final updatedId = await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);

    return transaction;
  }

  @override
  Future<List<String>> getAvailablePeriods() async {
    final db = await _databaseHelper.database;

    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT strftime('%m', date) as month, strftime('%Y', date) as year
      FROM transactions
      GROUP BY year, month
      ORDER BY year ASC, month ASC
      ''');

    List<String> periods = result.map((row) {
      String month = row['month'];
      String year = row['year'].substring(2);

      Map<String, String> monthMapping = {
        '01': 'JAN',
        '02': 'FEV',
        '03': 'MAR',
        '04': 'ABR',
        '05': 'MAI',
        '06': 'JUN',
        '07': 'JUL',
        '08': 'AGO',
        '09': 'SET',
        '10': 'OUT',
        '11': 'NOV',
        '12': 'DEZ',
      };

      return '${monthMapping[month]}/$year';
    }).toList();

    return periods;
  }

  @override
  Future<Transaction?> getById(id) async {
    var database = await _databaseHelper.database;

    final found = await database.rawQuery('''
      SELECT 
        transactions.id,
        transactions.description,
        transactions.value,
        transactions.category_id,
        transactions.subcategory_id,
        transactions.type_id,
        transactions.payment_method_id,
        transactions.date,     
        transactions.invoice_id,
        categories.name AS category_name,
        categories.icon AS category_icon,
        categories.color AS category_color,
        subcategories.name AS subcategory_name,
        subcategories.icon AS subcategory_icon,
        subcategories.color AS subcategory_color,
        transaction_types.name AS type,
        payment_methods.name AS payment_method
      FROM transactions
      LEFT JOIN categories ON transactions.category_id = categories.id
      LEFT JOIN subcategories ON transactions.subcategory_id = subcategories.id
      LEFT JOIN transaction_types ON transactions.type_id = transaction_types.id
      LEFT JOIN payment_methods ON transactions.payment_method_id = payment_methods.id
      WHERE transactions.id = $id
      ORDER BY transactions.date DESC
    ''');

    return found.first.isNotEmpty ? Transaction.fromMap(found.first) : null;
  }
}
