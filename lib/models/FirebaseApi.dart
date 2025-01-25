import 'package:firebase_messaging/firebase_messaging.dart'
    show AuthorizationStatus, FirebaseMessaging;
import 'package:firebase_messaging/firebase_messaging.dart'
as firebase_messaging;

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications({required bool enableNotifications}) async {
    if (!enableNotifications) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

      FirebaseMessaging.onMessage.listen((event) {}).cancel();
      await _firebaseMessaging.unsubscribeFromTopic('all_users');

      print('Notifications disabled');
      return;
    }

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    firebase_messaging.NotificationSettings settings =
    await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _firebaseMessaging.subscribeToTopic('all_users');
    }
  }
}