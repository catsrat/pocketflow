import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'pocketflow.db';
  static const _dbVersion = 1;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        colorHex TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        categoryId INTEGER NOT NULL,
        note TEXT,
        paymentMethod TEXT,
        createdAt TEXT NOT NULL
      );
    ''');
    final defaultCategories = [
      {'name': 'Food', 'icon': 'restaurant', 'colorHex': '#FF7043'},
      {'name': 'Transport', 'icon': 'directions_car', 'colorHex': '#29B6F6'},
      {'name': 'Rent', 'icon': 'home', 'colorHex': '#8E24AA'},
      {'name': 'Shopping', 'icon': 'shopping_bag', 'colorHex': '#FFB300'},
      {'name': 'Other', 'icon': 'more_horiz', 'colorHex': '#9E9E9E'},
    ];
    for (final c in defaultCategories) {
      await db.insert('categories', c);
    }
  }
  Future close() async {
    final db = await database;
    return db.close();
  }
}
