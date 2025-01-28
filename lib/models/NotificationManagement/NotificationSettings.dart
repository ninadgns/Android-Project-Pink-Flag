// lib/models/NotificationManagement/NotificationSettings.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends ChangeNotifier {
  bool _isNotificationsEnabled = false;

  bool get isNotificationsEnabled => _isNotificationsEnabled;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationsEnabled = prefs.getBool('isNotificationsEnabled') ?? false;
    notifyListeners();
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    _isNotificationsEnabled = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsEnabled', isEnabled);
    notifyListeners();
  }
}