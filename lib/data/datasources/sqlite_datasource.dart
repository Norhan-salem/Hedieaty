import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hedieaty.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      username TEXT UNIQUE,
      email TEXT,
      password TEXT,
      phone_number TEXT, 
      profile_image_path TEXT, 
      preferences INTEGER DEFAULT 0 -- 0 (notif), 1 (no notif)
    );
    
    CREATE TABLE events (
      id INTEGER PRIMARY KEY,
      name TEXT,
      date TEXT, 
      location TEXT,
      description TEXT,
      category INTEGER,
      user_id INTEGER,
      isDeleted INTEGER DEFAULT 0,
      FOREIGN KEY(user_id) REFERENCES users(id)
    );
    
    CREATE TABLE gifts (
      id INTEGER PRIMARY KEY,
      name TEXT,
      gift_image_path TEXT,  -- Local image path or URL
      description TEXT,
      category INTEGER,
      price REAL,
      status INTEGER,  -- 0 for available, 1 for pledged, 2 for purchased.
      event_id INTEGER,
      pledged_by_user_id INTEGER,
      isDeleted INTEGER DEFAULT 0,
      FOREIGN KEY(event_id) REFERENCES events(id)
      FOREIGN KEY(pledged_by_user_id) REFERENCES users(id)
    );
    
    CREATE TABLE friends (
      user_id INTEGER,
      friend_id INTEGER,
      PRIMARY KEY(user_id, friend_id),
      FOREIGN KEY(user_id) REFERENCES users(id),
      FOREIGN KEY(friend_id) REFERENCES users(id)
    );
    ''');
  }
}

