import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;
  static const String tableName = 'reviews';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'reviews_database.db');

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userEmail TEXT,
            productType TEXT,
            review TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> addReview(String userEmail, String productType, String review) async {
    final Database db = await database;

    await db.insert(
      tableName,
      {
        'userEmail': userEmail,
        'productType': productType,
        'review': review,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    final Database db = await database;
    return await db.query(tableName);
  }
}
