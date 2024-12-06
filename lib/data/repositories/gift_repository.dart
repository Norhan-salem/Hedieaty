import 'package:sqflite/sqflite.dart';

import '../../domain/enums/GiftStatus.dart';
import '../datasources/sqlite_datasource.dart';
import '../models/gift_model.dart';


class GiftRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();

  Future<int> createGift(Gift gift) async {
    final db = await _sqliteDataSource.database;
    return await db.insert(
      'gifts',
      gift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateGift(int giftId, Map<String, dynamic> updatedFields) async {
    final db = await _sqliteDataSource.database;

    final gift = await fetchGiftById(giftId);
    if (gift != null && gift.giftStatus == GiftStatus.pledged) {
      throw Exception("Pledged gifts cannot be updated");
    }
    return await db.update(
      'gifts',
      updatedFields,
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }

  Future<int> deleteGift(int giftId) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'gifts',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }

  Future<int> pledgeGift(int giftId, String userId) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'gifts',
      {
        'status': GiftStatus.pledged.index,
        'pledged_by_user_id': userId,
      },
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [giftId],
    );
  }

  Future<int> unpledgeGift(int giftId) async {
    final db = await _sqliteDataSource.database;
    return await db.update(
      'gifts',
      {
        'status': GiftStatus.available.index,
        'pledged_by_user_id': null,
      },
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [giftId],
    );
  }

  Future<Gift?> fetchGiftById(int giftId) async {
    final db = await _sqliteDataSource.database;

    final List<Map<String, dynamic>> result = await db.query(
      'gifts',
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [giftId],
    );

    if (result.isNotEmpty) {
      return Gift.fromMap(result.first);
    }

    return null;
  }
}

