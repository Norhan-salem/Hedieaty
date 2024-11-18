import 'package:sqflite/sqflite.dart';

import '../datasources/database_helper.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class FriendRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Friend>> getFriendsByUserId(int userId) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'friends',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Friend.fromMap(map)).toList();
  }

  Future<List<User>> searchFriendsByUsername(
      String searchQuery, int userId) async {
    final db = await _databaseHelper.database;

    // Search by username (case-insensitive)
    final result = await db.query(
      'users',
      where: 'username LIKE ? AND id != ?',
      whereArgs: ['%$searchQuery%', userId],
    );

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<List<User>> searchFriendsByEmail(
      String searchQuery, int userId) async {
    final db = await _databaseHelper.database;

    // Search by email
    final result = await db.query(
      'users',
      where: 'email = ? AND id != ?',
      whereArgs: ['%$searchQuery%', userId],
    );
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> addFriendByEmail(int userId, String email) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      final friend = User.fromMap(result.first);
      final friendId = friend.id;

      if (friendId != userId) {
        // Insert the friendship relationship (two-way)
        final friend1 = Friend(userId: userId, friendId: friendId);
        final friend2 = Friend(userId: friendId, friendId: userId);

        await db.insert(
          'friends',
          friend1.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        await db.insert(
          'friends',
          friend2.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        return 1;
      } else {
        return -1;
      }
    }

    return 0;
  }
}
