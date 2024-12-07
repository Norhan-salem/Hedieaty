import 'package:shared_preferences/shared_preferences.dart';

class NotifPreferencesService {
  static const _notificationsKey = 'notifications_enabled';

  Future<bool> getNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true; // Default is notif enabled
  }

  Future<bool> setNotificationPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_notificationsKey, isEnabled);
  }
}
