import 'package:billy/models/credit_card_invoice/credit_card_invoice_model.dart';
import 'package:billy/repositories/credit_card_invoices/i_credit_card_invoices_repository.dart';
import 'package:billy/repositories/database_helper.dart';

class CreditCardInvoicesRepository extends ICreditCardInvoicesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<CreditCardInvoiceModel> create(CreditCardInvoiceModel invoice) async {
    var db = await _databaseHelper.database;
    var createdId = await db.insert('credit_card_invoices', invoice.toMap());
    return invoice.copyWith(id: createdId);
  }

  @override
  Future<List<CreditCardInvoiceModel>> get({int? limit}) async {
    var db = await _databaseHelper.database;
    var result = await db.query("credit_card_invoices",
        limit: limit, orderBy: 'begin_date DESC');

    return result.map((el) {
      return CreditCardInvoiceModel.fromMap(el);
    }).toList();
  }

  @override
  Future<CreditCardInvoiceModel> getById(int id) async {
    var db = await _databaseHelper.database;

    var result = await db.query('credit_card_invoices', where: "id = ?", whereArgs: [id]);
    return CreditCardInvoiceModel.fromMap(result.first);
  }

  @override
  Future<CreditCardInvoiceModel> update(CreditCardInvoiceModel invoice) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<CreditCardInvoiceModel> getMostRecent() async {
    var db = await _databaseHelper.database;

    var result = await db.rawQuery('''
      SELECT * from credit_card_invoices
      ORDER BY begin_date DESC
      LIMIT 1;
    ''');

    return CreditCardInvoiceModel.fromMap(result.first);
  }

  @override
  Future<CreditCardInvoiceModel?> getByBeginDate(DateTime date) async {
    var db = await _databaseHelper.database;

    String month =
        date.month.toString().padLeft(2, '0'); // Formatar mês com dois dígitos
    String year = date.year.toString();

    var result = await db.rawQuery('''
      SELECT * FROM credit_card_invoices
      WHERE strftime('%m', begin_date) = ? AND strftime('%Y', begin_date) = ?
    ''', [month, year]);

    if (result.isNotEmpty) {
      return CreditCardInvoiceModel.fromMap(result.first);
    }

    return null;
  }

  @override
  Future<CreditCardInvoiceModel?> getNextInvoice(DateTime date) async {
    var db = await _databaseHelper.database;

    var result = await db.rawQuery('''
      SELECT * FROM credit_card_invoices
      WHERE begin_date > ?
      ORDER BY begin_date ASC
      LIMIT 1
    ''', [date.toIso8601String()]);

    if (result.isNotEmpty) {
      return CreditCardInvoiceModel.fromMap(result.first);
    }

    return null;
  }

  @override
  Future<CreditCardInvoiceModel?> getPreviousInvoice(DateTime date) async {
    var db = await _databaseHelper.database;

    var result = await db.rawQuery('''
      SELECT * FROM credit_card_invoices
      WHERE end_date < ?
      ORDER BY end_date DESC
      LIMIT 1
    ''', [date.toIso8601String()]);

    if (result.isNotEmpty) {
      return CreditCardInvoiceModel.fromMap(result.first);
    }

    return null;
  }

  @override
  Future<void> updateTotal(int id, double total) async{
    var db = await _databaseHelper.database;
    await db.update('credit_card_invoices', {"total":total}, where: "id = ?", whereArgs: [id]);
  }
}
