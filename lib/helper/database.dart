import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'address';

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'address.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            address TEXT,
            apartment TEXT,
            maplink TEXT
          )
        ''');
    });
  }

  Future<void> insertUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(tableName, userData);
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<void> deleteUserData(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> doesUserDataExist(String address, String apartment) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'address = ? AND apartment = ?',
      whereArgs: [address, apartment],
    );
    return result.isNotEmpty;
  }
}
