import 'package:sqflite/sqflite.dart';

import '../datasources/sqlite_datasource.dart';
import '../models/user_model.dart';
import '../services/authentication_service.dart';

class UserRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();

  Future<int> createUser(User user) async {
    try {
      final db = await _sqliteDataSource.database;

      final result = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('User created in local DB with ID: ${user.id}');
      return result;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }


  Future<User?> fetchCurrentUser() async {
    final db = await _sqliteDataSource.database;
    final firebaseUserId = AuthService().getCurrentUser()?.uid;

    if (firebaseUserId == null) {
      return null;
    }

    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [firebaseUserId],
      limit: 1,
    );

    if (userMaps.isNotEmpty) {
      return User.fromMap(userMaps.first);
    }

    return null;
  }

  Future<User?> fetchUser(String userId) async {
    try {
      final db = await _sqliteDataSource.database;
      final List<Map<String, dynamic>> userMaps = await db.query(
        'users',
        where: 'id = ? AND isDeleted = 0',
        whereArgs: [userId],
        limit: 1,
      );

      if (userMaps.isNotEmpty) {
        return User.fromMap(userMaps.first);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }


  Future<int> updateUserField(String userId, String field, dynamic newValue) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'users',
      {field: newValue},
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(String userId) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'users',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}

