import 'package:sqflite/sqflite.dart';

import '../datasources/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<User?> getUserById(int userId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.query(
        'users',
        where: 'id = ? AND isDeleted = 0',
        whereArgs: [userId],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error fetching user by ID $userId: $e');
      throw Exception('Failed to fetch user by ID.');
    }
  }

  Future<int> createUser(User user) async {
    try {
      final db = await _databaseHelper.database;
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        print('Error: Username or email already taken.');
        throw Exception('Username or email already exists.');
      }
      print('DatabaseException during user creation: $e');
      throw Exception('Failed to create user. Please try again.');
    } catch (e) {
      print('Unexpected error creating user: $e');
      throw Exception('An unexpected error occurred while creating the user.');
    }
  }

  Future<int> updateUser(User user) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (rowsAffected == 0) {
        throw Exception('No user found with ID ${user.id}');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException during user update: $e');
      throw Exception('Failed to update user. Please try again.');
    } catch (e) {
      print('Unexpected error updating user: $e');
      throw Exception('An unexpected error occurred while updating the user.');
    }
  }

  Future<int> deleteUser(int userId) async {
    try {
      final db = await _databaseHelper.database;
      final rowsAffected = await db.update(
        'users',
        {'isDeleted': 1},
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (rowsAffected == 0) {
        throw Exception('No user found with ID $userId');
      }

      return rowsAffected;
    } on DatabaseException catch (e) {
      print('DatabaseException during user deletion: $e');
      throw Exception('Failed to delete user. Please try again.');
    } catch (e) {
      print('Unexpected error deleting user: $e');
      throw Exception('An unexpected error occurred while deleting the user.');
    }
  }
}
