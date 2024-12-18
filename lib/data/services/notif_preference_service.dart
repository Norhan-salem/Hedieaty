import 'package:shared_preferences/shared_preferences.dart';

class NotifPreferencesService {
  static const _notificationsKey = 'notifications_enabled';

  Future<bool> getNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled =
        prefs.getBool(_notificationsKey) ?? true; // Default is enabled
    print("Notification preference fetched: $notificationsEnabled");
    return notificationsEnabled;
  }

  Future<void> setNotificationPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, isEnabled);
    print("Notification preference set: $isEnabled");
  }
}
