import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';
import 'package:billy/utils/date_utils.dart';

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
        IFNULL((
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
        ), 0) AS current_value
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
  Future<LimitModel> getById(int id) async {
    var db = await _databaseHelper.database;
    final limit = await db.rawQuery('''
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
        IFNULL((
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
        ), 0) AS current_value
      FROM limits
      LEFT JOIN categories ON limits.category_id = categories.id
      LEFT JOIN subcategories ON limits.subcategory_id = subcategories.id
      LEFT JOIN payment_methods ON limits.payment_method_id = payment_methods.id
      LEFT JOIN transaction_types ON limits.transaction_type_id = transaction_types.id    
      WHERE limits.id = $id
    ''');

    return LimitModel.fromMap(limit.first);
  }

  @override
  Future<LimitModel?> getRecent() {
    // TODO: implement getRecent
    throw UnimplementedError();
  }

  @override
  Future<LimitModel> update(LimitModel limit) async{
    var db = await _databaseHelper.database;

    final oldLimit = await getById(limit.id!);
    final changedBeginDate = !MyDateUtils.isSameDate(oldLimit!.beginDate, limit.beginDate);
    final changedEndDate = !MyDateUtils.isSameDate(oldLimit!.endDate, limit.endDate);

    await db.update("limits", limit.toMap(), where: 'id = ?', whereArgs: [limit.id]);

    var updatedLimit = limit;

    if(changedBeginDate || changedEndDate){
      updatedLimit = await getById(limit.id!);
    }


    return updatedLimit;
  }

  @override
  Future<double> recalcValueByLimitId(int id) async {
    var db = await _databaseHelper.database;

    final findLimitResult = await db.query('limits', where: 'id = ?', whereArgs: [id]);
    if(findLimitResult.isEmpty){
      throw Exception("Limite não encontrado");
    }

    var newValue = await db.rawQuery('''
    
      SELECT SUM(transactions.value) AS current_value
      FROM transactions
      WHERE 
        transactions.date BETWEEN limits.begin_date AND limits.end_date
        AND (
          transactions.category_id = limits.category_id
          OR transactions.subcategory_id = limits.subcategory_id
          OR transactions.payment_method_id = limits.payment_method_id
          OR transactions.type_id = limits.transaction_type_id
        )
    ''');

    return double.tryParse(newValue.first['current_value'].toString()) ?? 0;

  }
}
