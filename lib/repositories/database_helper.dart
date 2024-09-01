import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "my_database.db");

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER,
        subcategory_id INTEGER,
        value REAL NOT NULL,
        type_id INT NOT NULL,
        payment_method_id INT NOT NULL,
        paid INTEGER,
        date TEXT NOT NULL,
        end_date TEXT,
        FOREIGN KEY (type_id) REFERENCES transaction_types(id),
        FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
        FOREIGN KEY (category_id) REFERENCES categories(id),
        FOREIGN KEY (subcategory_id) REFERENCES subcategories(id)
      );
    ''');

    db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        max REAL,
        color INT
      );
    ''');

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

    db.execute('''
      CREATE TABLE balance (
        credit_limit REAL DEFAULT 0,
        credit_limit_used REAL DEFAULT 0,
        balance REAL DEFAULT 0
      );
    ''');

    db.execute('''
      CREATE TABLE transaction_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    //DEFAULT TRANSACTION TYPES
    await db.insert('transaction_types', {'name': 'INCOME'});
    await db.insert('transaction_types', {'name': 'EXPENSE'});
    await db.insert('transaction_types', {'name': 'TRANSFER'});

    //DEFAULT PAYMENT METHODS
    await db.insert('payment_methods', {'name': 'PIX'});
    await db.insert('payment_methods', {'name': 'CREDIT_CARD'});
    await db.insert('payment_methods', {'name': 'MONEY'});

    //DEFAULT BALANCE
    await db.insert('balance', {'credit_limit':0, 'credit_limit_used':0, 'balance':0});
  }
}
