import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorageService {
  static const String _notificationsKey = 'notifications_queue';

  /// Fetch all notifications
  static Future<List<String>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(_notificationsKey);
    return notifications ?? [];
  }

  /// Add a new notification to the queue
  static Future<void> addNotification(String notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(_notificationsKey) ?? [];
    notifications.add(notification);
    await prefs.setStringList(_notificationsKey, notifications);
  }

  /// Clear all notifications
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  /// Remove a specific notification (optional)
  static Future<void> removeNotification(String notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(_notificationsKey) ?? [];
    notifications.remove(notification);
    await prefs.setStringList(_notificationsKey, notifications);
  }
}
