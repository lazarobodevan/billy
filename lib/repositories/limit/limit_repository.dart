import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';

class LimitRepository extends ILimitRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<LimitModel> create(LimitModel limit) async {
    var db = await _databaseHelper.database;
    var createdId = await db.insert("limits", limit.toMap());
    return limit.copyWith(id: createdId);
  }

  @override
  Future<void> delete(int id) async {
    var db = await _databaseHelper.database;

    await db.delete("limits", where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<List<LimitModel>> getAll() async {
    var db = await _databaseHelper.database;
    var limits = await db.rawQuery('''
      SELECT 
        limits.id AS limit_id,
        limits.*,
        categories.id AS category_id,
        categories.name AS category_name,
        subcategories.id AS subcategory_id,
        subcategories.name AS subcategory_name,
        payment_methods.id AS payment_method_id,
        payment_methods.name AS payment_method_name,
        transaction_types.id AS transaction_type_id,
        transaction_types.name AS transaction_type_name, 
        
        -- Subconsulta para calcular o current_value
        (
          SELECT SUM(transactions.value)
          FROM transactions
          WHERE 
            transactions.date BETWEEN limits.begin_date AND limits.end_date
            AND (
              transactions.category_id = limits.category_id
              OR transactions.subcategory_id = limits.subcategory_id
              OR transactions.payment_method_id = limits.payment_method_id
              OR transactions.type_id = limits.transaction_type_id
            )
        ) AS current_value
      FROM limits
      LEFT JOIN categories ON limits.category_id = categories.id
      LEFT JOIN subcategories ON limits.subcategory_id = subcategories.id
      LEFT JOIN payment_methods ON limits.payment_method_id = payment_methods.id
      LEFT JOIN transaction_types ON limits.transaction_type_id = transaction_types.id    
    ''');

    return limits.map((limit) {
      return LimitModel.fromMap(limit);
    }).toList();
  }

  @override
  Future<LimitModel?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<LimitModel?> getRecent() {
    // TODO: implement getRecent
    throw UnimplementedError();
  }

  @override
  Future<LimitModel> update(LimitModel limit) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
