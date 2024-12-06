import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDataSource {
  static final SqliteDataSource _instance = SqliteDataSource._internal();
  factory SqliteDataSource() => _instance;
  static Database? _database;

  SqliteDataSource._internal();

  Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
  }

  Future<Database> _initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'hedieaty.db');

  return await openDatabase(
  path,
  version: 1,
  onCreate: _onCreate,
  );
  }

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT NOT NULL PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        profile_image_path TEXT,
        isDeleted INTEGER DEFAULT 0
      )
    ''');

  await db.execute('''
      CREATE TABLE IF NOT EXISTS events (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        location TEXT,
        description TEXT,
        category INTEGER,
        user_id TEXT,
        isDeleted INTEGER DEFAULT 0,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

  await db.execute('''
      CREATE TABLE IF NOT EXISTS gifts (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        gift_image_path TEXT,
        description TEXT,
        category INTEGER,
        price REAL,
        status INTEGER,
        event_id INTEGER,
        pledged_by_user_id TEXT,
        isDeleted INTEGER DEFAULT 0,
        isPublished INTEGER DEFAULT 0,
        FOREIGN KEY(event_id) REFERENCES events(id),
        FOREIGN KEY(pledged_by_user_id) REFERENCES users(id)
      )
    ''');

  await db.execute('''
      CREATE TABLE IF NOT EXISTS friends (
        user_id TEXT,
        friend_id TEXT,
        PRIMARY KEY(user_id, friend_id),
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(friend_id) REFERENCES users(id)
      )
    ''');
  }
}


