import 'package:cloud_firestore/cloud_firestore.dart';

import '../datasources/sqlite_datasource.dart';
import '../models/user_model.dart';
import '../services/authentication_service.dart';

/// Repository for handling user-related operations in Firestore.
///
/// This repository interfaces with Firestore to perform CRUD operations
/// for the `User` model. It uses the logged-in user's ID for context-sensitive
/// operations like fetching the current user.
class UserRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates or updates a user in Firestore.
  ///
  /// [user]: The `User` object to be created or updated in Firestore.
  ///
  /// This method merges the `User` document with any existing data
  /// to avoid overwriting other fields.
  /// Returns `true` if the operation is successful, otherwise `false`.
  Future<bool> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
            user.toMap(),
            SetOptions(merge: true),
          );
      print('User created/updated in Firestore with ID: ${user.id}');
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  /// Fetches the current user from Firestore based on the logged-in user's ID.
  ///
  /// Returns a `User` object if the current user exists in Firestore,
  /// otherwise returns `null`.
  Future<User?> fetchCurrentUser() async {
    try {
      final firebaseUser = await AuthService().getCurrentUser();
      if (firebaseUser == null) {
        print('No current user is logged in.');
        return null;
      }
      final firebaseUserId = firebaseUser.uid;
      final doc =
          await _firestore.collection('users').doc(firebaseUserId).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (data['isDeleted'] == true) {
          print('Current user is marked as deleted.');
          return null;
        }
        return User.fromMap(data);
      } else {
        print('User document not found in Firestore.');
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
    return null;
  }

  /// Fetches a specific user by their ID from Firestore.
  ///
  /// [userId]: The ID of the user to fetch.
  ///
  /// Returns a `User` object if the user exists in Firestore,
  /// otherwise returns `null`.
  Future<User?> fetchUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (data['isDeleted'] == true) {
          print('User $userId is marked as deleted.');
          return null;
        }
        return User.fromMap(data);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  /// Updates a specific field for a user in Firestore.
  ///
  /// [userId]: The ID of the user to update.
  /// [field]: The name of the field to update.
  /// [newValue]: The new value for the specified field.
  ///
  /// Returns `true` if the update is successful, otherwise `false`.
  Future<bool> updateUserField(
      String userId, String field, dynamic newValue) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (data['isDeleted'] == true) {
          print('User $userId is marked as deleted. Update skipped.');
          return false;
        }
        await _firestore
            .collection('users')
            .doc(userId)
            .update({field: newValue});
        print('Updated $field for user $userId in Firestore.');
        return true;
      }
    } catch (e) {
      print('Error updating user field: $e');
    }
    return false;
  }

  /// Marks a user as deleted in Firestore by setting `isDeleted` to true.
  ///
  /// [userId]: The ID of the user to mark as deleted.
  ///
  /// Returns `true` if the operation is successful, otherwise `false`.
  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'isDeleted': true});
      print('User $userId marked as deleted in Firestore.');
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

// Future<int> createUser(User user) async {
//   try {
//     final db = await _sqliteDataSource.database;
//
//     final result = await db.insert(
//       'users',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//
//     print('User created in local DB with ID: ${user.id}');
//     return result;
//   } catch (e) {
//     print('Error creating user: $e');
//     rethrow;
//   }
// }
//
//
// Future<User?> fetchCurrentUser() async {
//   final db = await _sqliteDataSource.database;
//   final firebaseUserId = AuthService().getCurrentUser()?.uid;
//
//   if (firebaseUserId == null) {
//     return null;
//   }
//
//   final List<Map<String, dynamic>> userMaps = await db.query(
//     'users',
//     where: 'id = ? AND isDeleted = 0',
//     whereArgs: [firebaseUserId],
//     limit: 1,
//   );
//
//   if (userMaps.isNotEmpty) {
//     return User.fromMap(userMaps.first);
//   }
//
//   return null;
// }
//
// Future<User?> fetchUser(String userId) async {
//   try {
//     final db = await _sqliteDataSource.database;
//     final List<Map<String, dynamic>> userMaps = await db.query(
//       'users',
//       where: 'id = ? AND isDeleted = 0',
//       whereArgs: [userId],
//       limit: 1,
//     );
//
//     if (userMaps.isNotEmpty) {
//       return User.fromMap(userMaps.first);
//     }
//     return null;
//   } catch (e) {
//     print('Error fetching user: $e');
//     return null;
//   }
// }
//
//
// Future<int> updateUserField(String userId, String field, dynamic newValue) async {
//   final db = await _sqliteDataSource.database;
//   return await db.update(
//     'users',
//     {field: newValue},
//     where: 'id = ? AND isDeleted = 0',
//     whereArgs: [userId],
//   );
// }
//
// Future<int> deleteUser(String userId) async {
//   final db = await _sqliteDataSource.database;
//   return await db.update(
//     'users',
//     {'isDeleted': 1},
//     where: 'id = ?',
//     whereArgs: [userId],
//   );
// }
}
