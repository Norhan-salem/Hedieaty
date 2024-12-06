import 'package:sqflite/sqflite.dart';
import '../datasources/sqlite_datasource.dart';
import '../models/event_model.dart';


class EventRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();

  Future<int> createEvent(Event event) async {
    final db = await _sqliteDataSource.database;

    return await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteEvent(int eventId) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'events',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<Event>> searchByName(String query) async {
    final db = await _sqliteDataSource.database;

    final List<Map<String, dynamic>> result = await db.query(
      'events',
      where: 'name LIKE ? AND isDeleted = 0',
      whereArgs: ['%$query%'],
    );

    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(int eventId, Map<String, dynamic> updatedFields) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'events',
      updatedFields,
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<Event>> fetchUserEvents(String userId) async {
    final db = await _sqliteDataSource.database;
    final List<Map<String, dynamic>> result = await db.query(
      'events',
      where: 'user_id = ? AND isDeleted = 0',
      whereArgs: [userId],
    );

    return result.map((map) => Event.fromMap(map)).toList();
  }
}



