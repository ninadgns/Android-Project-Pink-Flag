import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMesasging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMesasging.requestPermission();

    final fCMToken = await _firebaseMesasging.getToken();
    print('FCM Token: $fCMToken');
  }
}
