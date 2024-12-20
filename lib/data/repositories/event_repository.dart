import 'package:cloud_firestore/cloud_firestore.dart';

import '../datasources/sqlite_datasource.dart';
import '../models/event_model.dart';

class EventRepository {
  final SqliteDataSource _sqliteDataSource = SqliteDataSource();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    try {
      final eventRef = _firestore.collection('events').doc(event.id.toString());
      await eventRef.set({
        'name': event.name,
        'description': event.description,
        'category': event.category,
        'location': event.location,
        'date': event.date != null
            ? Timestamp.fromDate(DateTime.parse(event.date!))
            : null,
        'user_id': event.userId,
        'isDeleted': false,
      });
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      await _firestore.collection('events').doc(eventId.toString()).update({
        'isDeleted': true,
      });
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  Future<List<Event>> searchByName(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .where('isDeleted', isEqualTo: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data()!;
        return Event(
          id: int.parse(doc.id),
          name: data['name'],
          description: data['description'],
          category: data['category'],
          location: data['location'],
          date: data['date'] != null
              ? (data['date'] as Timestamp).toDate().toString()
              : '',
          userId: data['user_id'],
        );
      }).toList();
    } catch (e) {
      print('Error searching events: $e');
      rethrow;
    }
  }

  Future<void> updateEvent(
      int eventId, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId.toString())
          .update(updatedFields);
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  Future<List<Event>> fetchUserEvents(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .where('user_id', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data()!;
        return Event(
          id: int.parse(doc.id),
          name: data['name'],
          description: data['description'],
          category: data['category'],
          location: data['location'],
          date: data['date'] != null
              ? (data['date'] as Timestamp)
                  .toDate()
                  .toString()
              : '',
          userId: data['user_id'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching user events: $e');
      rethrow;
    }
  }

  Future<String?> getEventDate(int eventId) async {
    try {
      final eventDoc =
          await _firestore.collection('events').doc(eventId.toString()).get();

      if (eventDoc.exists) {
        final data = eventDoc.data()!;
        return data['date'] != null
            ? (data['date'] as Timestamp).toDate().toString()
            : null;
      }
      return null;
    } catch (e) {
      print('Error fetching event date: $e');
      return null;
    }
  }

  Future<String?> getEventOwner(int eventId) async {
    try {
      final eventDoc =
          await _firestore.collection('events').doc(eventId.toString()).get();

      if (eventDoc.exists) {
        final data = eventDoc.data()!;
        final userId = data['user_id'];
        final userDoc = await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          return userDoc.data()?['username'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching event owner: $e');
      return null;
    }
  }

// Future<int> createEvent(Event event) async {
//   final db = await _sqliteDataSource.database;
//
//   return await db.insert(
//     'events',
//     event.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }
//
// Future<int> deleteEvent(int eventId) async {
//   final db = await _sqliteDataSource.database;
//   return await db.update(
//     'events',
//     {'isDeleted': 1},
//     where: 'id = ?',
//     whereArgs: [eventId],
//   );
// }
//
// Future<List<Event>> searchByName(String query) async {
//   final db = await _sqliteDataSource.database;
//
//   final List<Map<String, dynamic>> result = await db.query(
//     'events',
//     where: 'name LIKE ? AND isDeleted = 0',
//     whereArgs: ['%$query%'],
//   );
//
//   return result.map((map) => Event.fromMap(map)).toList();
// }
//
// Future<int> updateEvent(int eventId, Map<String, dynamic> updatedFields) async {
//   final db = await _sqliteDataSource.database;
//   return await db.update(
//     'events',
//     updatedFields,
//     where: 'id = ?',
//     whereArgs: [eventId],
//   );
// }
//
// Future<List<Event>> fetchUserEvents(String userId) async {
//   final db = await _sqliteDataSource.database;
//   final List<Map<String, dynamic>> result = await db.query(
//     'events',
//     where: 'user_id = ? AND isDeleted = 0',
//     whereArgs: [userId],
//   );
//
//   return result.map((map) => Event.fromMap(map)).toList();
// }
//
// Future<DateTime?> getEventDate(int eventId) async {
//   try {
//     final db = await _sqliteDataSource.database;
//     final result = await db.query(
//       'events',
//       columns: ['date'],
//       where: 'id = ?',
//       whereArgs: [eventId],
//     );
//
//     if (result.isNotEmpty) {
//       return DateTime.parse(result.first['date'] as String);
//     }
//     return null;
//   } catch (e) {
//     print('Error fetching event date: $e');
//     return null;
//   }
// }
//
// Future<String?> getEventOwner(int eventId) async {
//   try {
//     final db = await _sqliteDataSource.database;
//     final result = await db.query(
//       'events',
//       columns: ['user_id'],
//       where: 'id = ?',
//       whereArgs: [eventId],
//       limit: 1,
//     );
//
//     if (result.isNotEmpty) {
//       final userId = result.first['user_id'] as String;
//       final user = await UserRepository().fetchUser(userId);
//
//       return user?.username;
//     }
//     return null;
//   } catch (e) {
//     print('Error fetching event owner: $e');
//     return null;
//   }
// }
}
