import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/enums/GiftStatus.dart';
import '../datasources/sqlite_datasource.dart';
import '../models/gift_model.dart';

class GiftRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> deleteGift(int giftId, int eventId) async {
    final db = await _sqliteDataSource.database;
    try {
      final localResult = await db.update(
        'gifts',
        {'isDeleted': 1},
        where: 'id = ?',
        whereArgs: [giftId],
      );

      if (localResult > 0) {
        print('Local soft delete succeeded for gift: $giftId');
      } else {
        print('Local soft delete failed for gift: $giftId');
      }

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .doc(giftId.toString())
          .update({'isDeleted': true});

      print('Firestore soft delete succeeded for gift: $giftId');
    } catch (e) {
      print('Error during gift deletion: $e');
      throw Exception('Failed to delete gift: $e');
    }
  }


  Future<bool> pledgeGift(int giftId, String userId, int eventId) async {
    try {
      final eventRef = _firestore.collection('events').doc(eventId.toString());
      final eventDoc = await eventRef.get();
      if (!eventDoc.exists) {
        print('Event not found.');
        return false;
      }

      final eventDate = (eventDoc.data()?['date'] as Timestamp).toDate();
      final currentDate = DateTime.now();

      if (eventDate.isBefore(currentDate)) {
        print('The event is in the past and cannot be pledged.');
        return false;
      }

      final giftRef = _firestore
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .doc(giftId.toString());

      final giftDoc = await giftRef.get();
      if (giftDoc.exists && giftDoc.data()?['pledged_by_user_id'] != '') {
        print('This gift is already pledged.');
        return false;
      }

      await giftRef.update({
        'status': GiftStatus.pledged.index,
        'pledged_by_user_id': userId,
      });

      final updatedFields = {
        'status': GiftStatus.pledged.index,
        'pledged_by_user_id': userId,
      };

      final rowsUpdated =
          await GiftRepository().updateGift(giftId, updatedFields);

      if (rowsUpdated > 0) {
        print(
            'Gift pledged successfully in Firestore and updated in local DB.');
        return true;
      } else {
        print('Failed to update the gift in the local database.');
        return false;
      }
    } catch (e) {
      print('Error pledging gift: $e');
      return false;
    }
  }

  Future<bool> unpledgeGift(int giftId, int eventId) async {
    try {
      final giftRef = _firestore
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .doc(giftId.toString());
      await giftRef.update({
        'status': GiftStatus.available.index,
        'pledged_by_user_id': '',
      });

      final updatedFields = {
        'status': GiftStatus.available.index,
        'pledged_by_user_id': '',
      };

      final rowsUpdated =
          await GiftRepository().updateGift(giftId, updatedFields);

      if (rowsUpdated > 0) {
        print(
            'Gift unpledged successfully in Firestore and updated in local DB.');
        return true;
      } else {
        print('Failed to update the gift in the local database.');
        return false;
      } // Success
    } catch (e) {
      print('Error unpledging gift: $e');
      return false;
    }
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

  Future<List<Gift>> fetchGiftsByEventId(int eventId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .where('isDeleted', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => Gift.fromMap(doc.data()))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching gifts: $e');
      return [];
    }
  }

  Future<List<Gift>> fetchLocalGiftsByEventId(int eventId) async {
    final db = await _sqliteDataSource.database;

    final publishedGifts = await fetchGiftsByEventId(eventId);
    final List<Map<String, dynamic>> localGifts = await db.query(
      'gifts',
      where: 'event_id = ? AND isDeleted = 0 AND isPublished = 0',
      whereArgs: [eventId],
    );

    final unpublishedGifts = localGifts.map((giftMap) => Gift.fromMap(giftMap)).toList();
    return [...publishedGifts, ...unpublishedGifts];
  }

  // Future<List<Gift>> fetchPledgedGiftsByUserId(String userId) async {
  //   final db = await _sqliteDataSource.database;
  //
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'gifts',
  //     where: 'pledged_by_user_id = ? AND isDeleted = 0',
  //     whereArgs: [userId],
  //   );
  //   return result.isNotEmpty
  //       ? result.map((giftMap) => Gift.fromMap(giftMap)).toList()
  //       : [];
  // }

  Future<List<Gift>> fetchPledgedGiftsByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('gifts')
          .where('pledged_by_user_id', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .get();

      return querySnapshot.docs
          .map((doc) => Gift.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching pledged gifts: $e');
      return [];
    }
  }

  Future<bool> publishGiftToFirestore(Gift gift) async {
    try {
      await _firestore
          .collection('events')
          .doc(gift.eventId.toString())
          .collection('gifts')
          .doc(gift.id.toString())
          .set(gift.toMap());
      return true;
    } catch (e) {
      print('Error publishing gift to Firestore: $e');
      return false;
    }
  }

  Future<bool> updateGiftInFirestore(
      int giftId, Map<String, dynamic> updatedFields, int eventId) async {
    try {
      final giftRef = _firestore
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .doc(giftId.toString());

      final giftDoc = await giftRef.get();
      final gift = Gift.fromMap(giftDoc.data()!);

      if (gift.giftStatus == GiftStatus.pledged) {
        throw Exception("Pledged gifts cannot be updated");
      }

      await giftRef.update(updatedFields);
      return true;
    } catch (e) {
      print('Error updating gift in Firestore: $e');
      return false;
    }
  }

  Future<bool> deleteGiftInFirestore(int giftId, int eventId) async {
    try {
      print('Attempting to soft delete gift: $giftId for event: $eventId');
      final docRef = _firestore
          .collection('events')
          .doc(eventId.toString())
          .collection('gifts')
          .doc(giftId.toString());

      await docRef.update({'isDeleted': true});
      print('Soft delete successful for gift: $giftId');
      return true;
    } catch (e) {
      print('Error deleting gift in Firestore: $e');
      return false;
    }
  }
}
