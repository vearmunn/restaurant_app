import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static late Database _database;
  final String tableName = 'favoriteRestaurant';

  Future<Database> initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restoran_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $tableName (
               id TEXT PRIMARY KEY,
               pictureId TEXT,
               name TEXT,
               city TEXT,
               rating REAL
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<Database> get database async {
    _database = await initializeDb();
    return _database;
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  Future insertFavorite(String id, String pictureId, String name, String city,
      double rating) async {
    final Database db = await database;
    final data = {
      'id': id,
      'pictureId': pictureId,
      'name': name,
      'city': city,
      'rating': rating
    };
    await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getFavoriteRestaurants() async {
    final Database db = await database;
    final List<Map<String, dynamic>> results = await db.query(tableName);

    return results;
  }

  Future getRestaurantById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results;
  }

  Future deleteFavoriteRestaurant(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
