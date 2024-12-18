import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';

import 'authentication_service.dart';
import 'notif_preference_service.dart';
import 'notif_storage_service.dart';

class GlobalGiftListener {
  static final GlobalGiftListener _instance = GlobalGiftListener._internal();

  factory GlobalGiftListener() => _instance;

  GlobalGiftListener._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize(String userId) {
    print("Initializing global gift listener for user: $userId");
    _firestore.collection('events').snapshots().listen((querySnapshot) {
      print("Received event snapshots");
      for (var doc in querySnapshot.docs) {
        final eventData = doc.data();
        final eventOwnerId = eventData?['user_id'];
        print("Event ID: ${doc.id}, Event Owner ID: $eventOwnerId");
        if (eventOwnerId == userId) {
          _listenToGiftsSubCollection(doc.id, userId);
        }
      }
    });
  }

  void _listenToGiftsSubCollection(String eventId, String userId) {
    print(
        "Listening to gifts subcollection for event: $eventId, user: $userId");
    _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .snapshots()
        .listen((querySnapshot) {
      print("Received gift snapshots for event: $eventId");
      for (var change in querySnapshot.docChanges) {
        print("Processing gift change: ${change.type}");
        if (change.type == DocumentChangeType.modified) {
          final giftData = change.doc.data();
          if (giftData != null &&
              giftData['pledged_by_user_id'] != '' &&
              giftData['pledged_by_user_id'] != userId) {
            print("Gift pledged by another user, preparing notification...");
            _handleGiftPledgedNotification(
              giftData['pledged_by_user_id'],
              giftData['name'],
            );
          }
        }
      }
    });
  }

  void _handleGiftPledgedNotification(String pledgerId, String giftName) async {
    print(
        "Handling gift pledged notification: pledgerId = $pledgerId, giftName = $giftName"); // Debugging statement

    final loginTime = await AuthService().getLoginTime();
    print("Login time retrieved: $loginTime");

    final notificationTime = DateTime.now().millisecondsSinceEpoch;
    print("Notification time: $notificationTime");

    FirebaseFirestore.instance
        .collection('users')
        .doc(pledgerId)
        .get()
        .then((userDoc) async {
      final username = userDoc.data()?['username'] ?? 'Someone';
      final message = '$username pledged your gift $giftName';
      print("Generated notification message: $message");

      NotificationStorageService.addNotification(message);
      print("Notification stored in SharedPreferences");

      if (loginTime != null && notificationTime >= loginTime) {
        final isNotificationsEnabled =
            await NotifPreferencesService().getNotificationPreference();
        print("Notifications enabled: $isNotificationsEnabled");
        if (isNotificationsEnabled) {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorPalette.darkPink,
            textColor: ColorPalette.eggShell,
          );
          print("Toast shown with message: $message");
        } else {
          print("Notifications are disabled, no toast shown.");
        }
      } else {
        print("Notification ignored because it was before login time.");
      }
    });
  }
}
