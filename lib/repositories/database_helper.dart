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
        value REAL NOT NULL,
        paid BOOLEAN NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        end_date TEXT,
        FOREIGN KEY (category_id) REFERENCES categories(id)
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
  }
}
