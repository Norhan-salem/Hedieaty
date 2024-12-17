import 'package:cloud_firestore/cloud_firestore.dart';

import '../datasources/sqlite_datasource.dart';
import '../models/user_model.dart';

class FriendRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addFriendByEmail(String userId, String friendEmail) async {
    try {
      final userQuerySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();
      if (userQuerySnapshot.docs.isEmpty) {
        throw Exception("User with email $friendEmail does not exist.");
      }
      final friendId = userQuerySnapshot.docs.first.id;
      final friendshipExistsForUser = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .get();

      final friendshipExistsForFriend = await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .get();

      if (friendshipExistsForUser.exists || friendshipExistsForFriend.exists) {
        throw Exception("Friendship already exists.");
      }
      final batch = _firestore.batch();
      final userFriendRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId);
      batch.set(userFriendRef, {'friend_id': friendId});

      final friendUserRef = _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId);
      batch.set(friendUserRef, {'friend_id': userId});

      await batch.commit();
      return true;
    } catch (e) {
      print("Error adding friend: $e");
      throw Exception("Failed to add friend: $e");
    }
  }

  Future<List<User>> searchForFriend(String query) async {
    final userQuerySnapshot = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThan: query + 'z')
        .get();

    return userQuerySnapshot.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<User>> fetchLoggedInUserFriends(String userId) async {
    final friendQuerySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();

    if (friendQuerySnapshot.docs.isEmpty) return [];

    final friendIds = friendQuerySnapshot.docs.map((doc) => doc.id).toList();

    final friendQueryResults = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendIds)
        .get();

    return friendQueryResults.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<int> deleteFriend(String userId, String friendId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .delete();

    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .delete();

    return 1;
  }

// Future<bool> addFriendByEmail(String userId, String friendEmail) async {
//   final db = await _sqliteDataSource.database;
//   final List<Map<String, dynamic>> result = await db.query(
//     'users',
//     where: 'email = ? AND isDeleted = 0',
//     whereArgs: [friendEmail],
//   );
//
//   if (result.isNotEmpty) {
//     final friendId = result.first['id'];
//     final existingFriendship = await db.query(
//       'friends',
//       where: '(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)',
//       whereArgs: [userId, friendId, friendId, userId],
//     );
//
//     if (existingFriendship.isEmpty) {
//       await db.insert(
//         'friends',
//         Friend(userId: userId, friendId: friendId).toMap(),
//       );
//       await db.insert(
//         'friends',
//         Friend(userId: friendId, friendId: userId).toMap(),
//       );
//       return true;
//     } else {
//       throw Exception("Friendship already exists.");
//     }
//   } else {
//     throw Exception("User with email $friendEmail does not exist.");
//   }
// }
//
//
// Future<List<User>> searchForFriend(String query) async {
//   final db = await _sqliteDataSource.database;
//
//   final List<Map<String, dynamic>> result = await db.query(
//     'users',
//     where:
//     '(username LIKE ? OR email LIKE ? OR phone_number LIKE ?) AND isDeleted = 0',
//     whereArgs: [
//       '%$query%',
//       '%$query%',
//       '%$query%',
//     ],
//   );
//
//   return result.map((map) => User.fromMap(map)).toList();
// }
//
// Future<List<User>> fetchLoggedInUserFriends(String userId) async {
//   final db = await _sqliteDataSource.database;
//   final List<Map<String, dynamic>> friendIdsResult = await db.query(
//     'friends',
//     where: 'user_id = ?',
//     whereArgs: [userId],
//   );
//
//   if (friendIdsResult.isEmpty) return [];
//   final friendIds = friendIdsResult.map((map) => map['friend_id']).toList();
//   final placeholders = List.generate(friendIds.length, (_) => '?').join(',');
//   final List<Map<String, dynamic>> friendsResult = await db.query(
//     'users',
//     where: 'id IN ($placeholders) AND isDeleted = 0',
//     whereArgs: friendIds,
//   );
//   return friendsResult.map((map) => User.fromMap(map)).toList();
// }
//
//
// Future<int> deleteFriend(String userId, String friendId) async {
//   final db = await _sqliteDataSource.database;
//
//   return await db.delete(
//     'friends',
//     where: 'user_id = ? AND friend_id = ?',
//     whereArgs: [userId, friendId],
//   );
// }
}
