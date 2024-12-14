import 'package:firebase_database/firebase_database.dart';
import 'package:hedieaty_flutter_application/data/datasources/sqlite_datasource.dart';
import 'package:sqflite/sqflite.dart';

import '../models/gift_model.dart';

class FirebaseDataSource {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> performFullSync(SqliteDataSource sqliteDataSource) async {
    try {
      await syncFromFirebase(sqliteDataSource);
      await syncToFirebase(sqliteDataSource);

      print('Full sync completed successfully.');
    } catch (e) {
      print('Error during full sync: $e');
    }
  }

  Future<void> syncToFirebase(SqliteDataSource sqliteDataSource) async {
    final Database db = await sqliteDataSource.database;

    await _syncUsers(db);
    await _syncEvents(db);
    await _syncGifts(db);
    await _syncFriends(db);
  }

  Future<void> _syncUsers(Database db) async {
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'isDeleted = ?',
      whereArgs: [0],
    );

    for (final user in users) {
      final String userId = user['id'];
      await databaseReference.child('users/$userId').set({
        'username': user['username'],
        'email': user['email'],
        'phone_number': user['phone_number'],
        'profile_image_path': user['profile_image_path'],
      });
    }
  }

  Future<void> _syncEvents(Database db) async {
    final List<Map<String, dynamic>> events = await db.query(
      'events',
      where: 'isDeleted = ?',
      whereArgs: [0],
    );

    for (final event in events) {
      final String eventId = event['id'].toString();
      await databaseReference.child('events/$eventId').set({
        'name': event['name'],
        'date': event['date'],
        'location': event['location'],
        'description': event['description'],
        'category': event['category'],
        'user_id': event['user_id'],
      });
    }
  }

  Future<void> _syncGifts(Database db) async {
    final List<Map<String, dynamic>> gifts = await db.query(
      'gifts',
      where: 'isDeleted = ? AND isPublished = ?',
      whereArgs: [0, 1],
    );

    for (final gift in gifts) {
      final String giftId = gift['id'].toString();
      await databaseReference.child('gifts/$giftId').set({
        'name': gift['name'],
        'gift_image_path': gift['gift_image_path'],
        'description': gift['description'],
        'category': gift['category'],
        'price': gift['price'],
        'status': gift['status'],
        'event_id': gift['event_id'],
        'pledged_by_user_id': gift['pledged_by_user_id'],
      });
    }
  }

  Future<void> _syncFriends(Database db) async {
    final List<Map<String, dynamic>> friends = await db.query('friends');

    for (final friend in friends) {
      final String userId = friend['user_id'];
      final String friendId = friend['friend_id'];

      await databaseReference.child('friends/$userId/$friendId').set(true);
    }
  }

  Future<void> syncFromFirebase(SqliteDataSource sqliteDataSource) async {
    final Database db = await sqliteDataSource.database;

    await _syncUsersFromFirebase(db);
    await _syncEventsFromFirebase(db);
    await _syncGiftsFromFirebase(db);
    await _syncFriendsFromFirebase(db);
  }

  Future<void> _syncUsersFromFirebase(Database db) async {
    final snapshot = await databaseReference.child('users').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> users = snapshot.value as Map;
      for (final userId in users.keys) {
        final user = users[userId];
        await db.insert(
          'users',
          {
            'id': userId,
            'username': user['username'],
            'email': user['email'],
            'phone_number': user['phone_number'],
            'profile_image_path': user['profile_image_path'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _syncEventsFromFirebase(Database db) async {
    final snapshot = await databaseReference.child('events').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> events = snapshot.value as Map;
      for (final eventId in events.keys) {
        final event = events[eventId];
        await db.insert(
          'events',
          {
            'id': int.parse(eventId),
            'name': event['name'],
            'date': event['date'],
            'location': event['location'],
            'description': event['description'],
            'category': event['category'],
            'user_id': event['user_id'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _syncGiftsFromFirebase(Database db) async {
    final snapshot = await databaseReference.child('gifts').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> gifts = snapshot.value as Map;
      for (final giftId in gifts.keys) {
        final gift = gifts[giftId];
        await db.insert(
          'gifts',
          {
            'id': int.parse(giftId),
            'name': gift['name'],
            'gift_image_path': gift['gift_image_path'],
            'description': gift['description'],
            'category': gift['category'],
            'price': gift['price'],
            'status': gift['status'],
            'event_id': gift['event_id'],
            'pledged_by_user_id': gift['pledged_by_user_id'],
            'isPublished': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _syncFriendsFromFirebase(Database db) async {
    final snapshot = await databaseReference.child('friends').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> friendsData = snapshot.value as Map;
      for (final userId in friendsData.keys) {
        final Map<dynamic, dynamic> friends = friendsData[userId];
        for (final friendId in friends.keys) {
          await db.insert(
            'friends',
            {
              'user_id': userId,
              'friend_id': friendId,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    }
  }

  Future<void> uploadPublishedGift(Gift gift) async {
    try {
      await databaseReference.child('gifts/${gift.id}').set(gift.toMap());
    } catch (e) {
      throw Exception('Failed to upload gift to Firebase: $e');
    }
  }
}
