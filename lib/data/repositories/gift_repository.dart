import 'package:sqflite/sqflite.dart';

import '../datasources/database_helper.dart';
import '../models/gift_model.dart';

class GiftRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Gift>> getGiftsByEventId(int eventId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'gifts',
        where: 'event_id = ? AND isDeleted = 0',
        whereArgs: [eventId],
      );
      return result.map((map) => Gift.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching gifts for event $eventId: $e');
      throw Exception('Failed to fetch gifts for the event.');
    }
  }

  Future<int> createGift(Gift gift) async {
    try {
      final db = await _databaseHelper.database;
      return await db.insert(
        'gifts',
        gift.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      print('DatabaseException when creating gift: $e');
      throw Exception('Failed to create gift. Please check your data.');
    } catch (e) {
      print('Error creating gift: $e');
      throw Exception('An unexpected error occurred while creating the gift.');
    }
  }

  Future<int> updateGift(Gift gift) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'gifts',
        gift.toMap(),
        where: 'id = ?',
        whereArgs: [gift.id],
      );

      if (rowsAffected == 0) {
        throw Exception('No gift found with ID ${gift.id}');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException when updating gift: $e');
      throw Exception('Failed to update gift. Please try again.');
    } catch (e) {
      print('Error updating gift: $e');
      throw Exception('An unexpected error occurred while updating the gift.');
    }
  }

  Future<int> deleteGift(int giftId) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'gifts',
        {'isDeleted': 1},
        where: 'id = ?',
        whereArgs: [giftId],
      );

      if (rowsAffected == 0) {
        throw Exception('No gift found with ID $giftId');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException when deleting gift: $e');
      throw Exception('Failed to delete gift. Please try again.');
    } catch (e) {
      print('Error deleting gift: $e');
      throw Exception('An unexpected error occurred while deleting the gift.');
    }
  }
}
