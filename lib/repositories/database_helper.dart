import 'dart:io';

import 'package:billy/utils/date_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper();

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static String _dbName = "my_database.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  getDbPath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, _dbName);
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDbPath();

    final database = await openDatabase(dbPath,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: (db, old, n) {});
    return database;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> changeDatabaseName(String newDbName) async {
    await closeDatabase();
    _dbName = newDbName;
    _database = await _initDatabase();
  }

  Future<void> restoreDatabaseFromFile(File backupFile) async {
    final newDbPath = await getDbPath();

    // Fechar o banco de dados atual
    await closeDatabase();

    // Copiar o arquivo de backup para o caminho do banco de dados
    await backupFile.copy(newDbPath);

    // Reabrir o banco de dados restaurado
    _database = await _initDatabase();
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async{
    if (oldV < 3) {
      await db.execute('''
      CREATE TABLE transactions_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,  -- Agora pode ser NULL
        category_id INTEGER,
        subcategory_id INTEGER,
        value REAL NOT NULL,
        type_id INT NOT NULL,
        payment_method_id INT NOT NULL,
        date TEXT NOT NULL,
        invoice_id INTEGER,
        FOREIGN KEY (type_id) REFERENCES transaction_types(id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
        FOREIGN KEY (category_id) REFERENCES categories(id),
        FOREIGN KEY (subcategory_id) REFERENCES subcategories(id),
        FOREIGN KEY (invoice_id) REFERENCES credit_card_invoices(id)
      );
    ''');

      // Copiar os dados da tabela antiga para a nova
      await db.execute('''
      INSERT INTO transactions_new (id, description, category_id, subcategory_id, value, type_id, payment_method_id, date, invoice_id)
      SELECT id, name, category_id, subcategory_id, value, type_id, payment_method_id, date, invoice_id FROM transactions;
    ''');

      // Remover a tabela antiga
      await db.execute('DROP TABLE transactions;');

      // Renomear a nova tabela para 'transactions'
      await db.execute('ALTER TABLE transactions_new RENAME TO transactions;');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    createTransactionsTable(db);
    createCategoriesTable(db);
    createSubcategoriesTable(db);
    createBalanceTable(db);
    createTransactionTypesTable(db);
    createPaymentMethodsTable(db);
    createGoalsTable(db);
    createLimitsTable(db);
    createCreditCardInvoicesTable(db);

    await insertDefaultValues(db);
  }

  Future<void> createTransactionsTable(Database db) async {
    db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT ,
        category_id INTEGER,
        subcategory_id INTEGER,
        value REAL NOT NULL,
        type_id INT NOT NULL,
        payment_method_id INT NOT NULL,
        date TEXT NOT NULL,
        invoice_id INTEGER,
        FOREIGN KEY (type_id) REFERENCES transaction_types(id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
        FOREIGN KEY (category_id) REFERENCES categories(id),
        FOREIGN KEY (subcategory_id) REFERENCES subcategories(id),
        FOREIGN KEY (invoice_id) REFERENCES credit_card_invoices(id)
      );
    ''');
  }

  Future<void> createCategoriesTable(Database db) async {
    db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        max REAL,
        color INT
      );
    ''');
  }

  Future<void> createSubcategoriesTable(Database db) async {
    db.execute('''
      CREATE TABLE subcategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        color INT,
        max REAL,
        category_id INTEGER,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');
  }

  Future<void> createBalanceTable(Database db) async {
    db.execute('''
      CREATE TABLE balance (
        credit_limit REAL DEFAULT 0,
        credit_limit_used REAL DEFAULT 0,
        balance REAL DEFAULT 0,
        invoice_pay_day INTEGER NOT NULL DEFAULT 1
      );
    ''');
  }

  Future<void> createTransactionTypesTable(Database db) async {
    db.execute('''
      CREATE TABLE transaction_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }

  Future<void> createPaymentMethodsTable(Database db) async {
    db.execute('''
      CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }

  Future<void> createGoalsTable(Database db) async {
    db.execute('''
      CREATE TABLE goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        target_value REAL NOT NULL,
        current_value REAL NOT NULL,
        target_date TEXT
      );
    ''');
  }

  Future<void> createLimitsTable(Database db) async {
    db.execute('''
      CREATE TABLE limits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        max_value REAL NOT NULL,
        recurrent INTEGER,
        begin_date TEXT,
        end_date TEXT,
        payment_method_id INTEGER,
        transaction_type_id INTEGER,
        category_id INTEGER,
        subcategory_id INTEGER,
        
        FOREIGN KEY(payment_method_id) REFERENCES payment_methods(id),
        FOREIGN KEY(transaction_type_id) REFERENCES transaction_types(id),
        FOREIGN KEY(category_id) REFERENCES categories(id),
        FOREIGN KEY(subcategory_id) REFERENCES subcategories(id)
      );
    ''');
  }

  Future<void> createCreditCardInvoicesTable(Database db) async {
    db.execute('''
      CREATE TABLE credit_card_invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total REAL NOT NULL DEFAULT 0,
        begin_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        paid INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertDefaultValues(Database db) async {
    //DEFAULT TRANSACTION TYPES
    await db.insert('transaction_types', {'name': 'INCOME'});
    await db.insert('transaction_types', {'name': 'EXPENSE'});
    await db.insert('transaction_types', {'name': 'TRANSFER'});

    //DEFAULT PAYMENT METHODS
    await db.insert('payment_methods', {'name': 'PIX'});
    await db.insert('payment_methods', {'name': 'CREDIT_CARD'});
    await db.insert('payment_methods', {'name': 'MONEY'});

    //DEFAULT BALANCE
    await db.insert('balance', {
      'credit_limit': 0,
      'credit_limit_used': 0,
      'balance': 0,
    });

    //DEFAULT CREDIT CARD INVOICE
    await db.insert('credit_card_invoices', {
      'id': 1,
      'total': 0,
      'begin_date': MyDateUtils.getFirstDayOfMonth().toIso8601String(),
      'end_date': MyDateUtils.getLastDayOfMonth().toIso8601String()
    });
  }
}
