import 'package:sqflite/sqflite.dart';

import '../../domain/enums/EventStatus.dart';
import '../datasources/database_helper.dart';
import '../models/event_model.dart';

class EventRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Event>> getEventsByUserId(int userId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'events',
        where: 'user_id = ? AND isDeleted = 0',
        whereArgs: [userId],
      );
      return result.map((map) => Event.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching events for user $userId: $e');
      throw Exception('Failed to fetch events for the user.');
    }
  }

  Future<int> createEvent(Event event) async {
    try {
      final db = await _databaseHelper.database;
      return await db.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      print('DatabaseException when creating event: $e');
      throw Exception('Failed to create event. Please try again.');
    } catch (e) {
      print('Error creating event: $e');
      throw Exception('An unexpected error occurred while creating the event.');
    }
  }

  Future<int> updateEvent(Event event) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'events',
        event.toMap(),
        where: 'id = ?',
        whereArgs: [event.id],
      );

      if (rowsAffected == 0) {
        throw Exception('No event found with ID ${event.id}');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException when updating event: $e');
      throw Exception('Failed to update event. Please try again.');
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('An unexpected error occurred while updating the event.');
    }
  }

  Future<int> deleteEvent(int eventId) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'events',
        {'isDeleted': 1},
        where: 'id = ?',
        whereArgs: [eventId],
      );

      if (rowsAffected == 0) {
        throw Exception('No event found with ID $eventId');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException when deleting event: $e');
      throw Exception('Failed to delete event. Please try again.');
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('An unexpected error occurred while deleting the event.');
    }
  }

  EventStatus getEventStatus(Event event) {
    final currentDate = DateTime.now();
    final eventDate = DateTime.parse(event.date);

    if (eventDate.isBefore(currentDate)) {
      return EventStatus.past;
    } else if (eventDate.isAfter(currentDate)) {
      return EventStatus.upcoming;
    } else {
      return EventStatus.current;
    }
  }
}
