import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOrah {
  Database? _database;
  final _tableName = 'cartData';

  // Open database connection
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If database does not exist, create it
    _database = await initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName(product_id VARCHAR UNIQUE)",
        );
      },
      version: 1,
    );
  }

  // Insert operation
  Future<void> insertData(String productId) async {
    final db = await database;
    await db.insert(
      _tableName,
      {'product_id': productId},
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete operation
  Future<void> deleteData(String productId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  // Delete all operation
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // Read operation
  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return db.query(_tableName);
  }

  // Example usage
  void readData() async {
    List<Map<String, dynamic>> dataList = await DatabaseOrah().getAllData();
    for (var data in dataList) {
      print('Product ID: ${data['product_id']}');
      // You can access other columns similarly
    }
  }
}
