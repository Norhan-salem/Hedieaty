import 'package:hedieaty_flutter_application/data/repositories/user_repository.dart';
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

  Future<DateTime?> getEventDate(int eventId) async {
    try {
      final db = await _sqliteDataSource.database;
      final result = await db.query(
        'events',
        columns: ['date'],
        where: 'id = ?',
        whereArgs: [eventId],
      );

      if (result.isNotEmpty) {
        return DateTime.parse(result.first['date'] as String);
      }
      return null;
    } catch (e) {
      print('Error fetching event date: $e');
      return null;
    }
  }

  Future<String?> getEventOwner(int eventId) async {
    try {
      final db = await _sqliteDataSource.database;
      final result = await db.query(
        'events',
        columns: ['user_id'],
        where: 'id = ?',
        whereArgs: [eventId],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final userId = result.first['user_id'] as String;
        final user = await UserRepository().fetchUser(userId);

        return user?.username;
      }
      return null;
    } catch (e) {
      print('Error fetching event owner: $e');
      return null;
    }
  }



}



