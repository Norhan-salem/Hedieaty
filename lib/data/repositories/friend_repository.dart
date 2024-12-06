import 'package:sqflite/sqflite.dart';

import '../datasources/sqlite_datasource.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';


class FriendRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();

  Future<bool> addFriendByEmail(String userId, String friendEmail) async {
    final db = await _sqliteDataSource.database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND isDeleted = 0',
      whereArgs: [friendEmail],
    );

    if (result.isNotEmpty) {
      final friendId = result.first['id'];
      final existingFriend = await db.query(
        'friends',
        where: 'user_id = ? AND friend_id = ?',
        whereArgs: [userId, friendId],
      );

      if (existingFriend.isEmpty) {
        await db.insert(
          'friends',
          Friend(userId: userId, friendId: friendId).toMap(),
        );
        return true;
      } else {
        throw Exception("Friendship already exists.");
      }
    } else {
      throw Exception("User with email $friendEmail does not exist.");
    }
  }

  Future<List<User>> searchForFriend(String query) async {
    final db = await _sqliteDataSource.database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where:
      '(username LIKE ? OR email LIKE ? OR phone_number LIKE ?) AND isDeleted = 0',
      whereArgs: [
        '%$query%',
        '%$query%',
        '%$query%',
      ],
    );

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<List<User>> fetchLoggedInUserFriends(String userId) async {
    final db = await _sqliteDataSource.database;
    final List<Map<String, dynamic>> friendIdsResult = await db.query(
      'friends',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (friendIdsResult.isEmpty) return [];
    final friendIds = friendIdsResult.map((map) => map['friend_id']).toList();
    final placeholders = List.generate(friendIds.length, (_) => '?').join(',');
    final List<Map<String, dynamic>> friendsResult = await db.query(
      'users',
      where: 'id IN ($placeholders) AND isDeleted = 0',
      whereArgs: friendIds,
    );
    return friendsResult.map((map) => User.fromMap(map)).toList();
  }


  Future<int> deleteFriend(String userId, String friendId) async {
    final db = await _sqliteDataSource.database;

    return await db.delete(
      'friends',
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, friendId],
    );
  }

  // Future<List<bool>> addFriendsThroughContactList(
  //     int userId, List<String> contactEmails) async {
  //   final db = await _sqliteDataSource.database;
  //   List<bool> results = [];
  //
  //   for (String email in contactEmails) {
  //     try {
  //       final added = await addFriendByEmail(userId, email);
  //       results.add(added);
  //     } catch (e) {
  //       results.add(false);
  //     }
  //   }
  //
  //   return results;
  // }
}

